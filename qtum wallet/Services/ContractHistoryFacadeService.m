//
//  ContractHistoryFacadeService.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 12.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "ContractHistoryFacadeService.h"
#import "TokenHistoryElement.h"
#import "TransactionReceipt+Extension.h"

@interface ContractHistoryFacadeService ()

@property (strong, nonatomic) id <Requestable> requestManager;
@property (strong, nonatomic) CoreDataService* storageService;
@property (copy, nonatomic) HistoryHendler delegateHandler;
@property (assign, nonatomic) NSInteger totalItems;
@property (strong, nonatomic) NSOperationQueue* receiptUpdatingQueue;
@property (strong, nonatomic) NSOperationQueue* workingQueue;

@end

static NSInteger batch = 25;

@implementation ContractHistoryFacadeService

- (instancetype)initWithRequestService:(id <Requestable>) requestManager andStorageService:(CoreDataService*) storageService {
    
    self = [super init];
    
    if (self) {
        _requestManager = requestManager;
        _storageService = storageService;
        _receiptUpdatingQueue = [NSOperationQueue new];
        _receiptUpdatingQueue.maxConcurrentOperationCount = 1;
        _workingQueue = [NSOperationQueue new];
        _workingQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (void)updateHistroyForAddresses:(NSArray *) keyAddreses withPage:(NSInteger) page withContractAddress:(NSString*) contractAddress withCurrency:(NSString*) currency withDecimals:(NSString*) decimals withHandler:(HistoryHendler) handler {
    
    
    __weak __typeof (self) weakSelf = self;
    
    NSBlockOperation* operation = [NSBlockOperation new];
    
    __weak NSBlockOperation *weakOperation = operation;

    [operation addExecutionBlock:^{
        
        if (weakOperation.isCancelled) {
            return;
        }
        
        NSDictionary* param = @{@"limit": @(batch),
                                @"offset": @(page * batch),
                                @"addresses[]" : keyAddreses
                                };
        
        weakSelf.delegateHandler = handler;
        
        [SLocator.requestManager getTokenHistoryWithParam:param
                                             tokenAddress:contractAddress
                                           successHandler:^(id responseObject, NSInteger totalCount) {
                                               
                                               if (weakOperation.isCancelled) {
                                                   return;
                                               }
                                               
                                               weakSelf.totalItems = totalCount;
                                               
                                               [weakSelf createHistoryElements:responseObject withCurrency:currency withDecimals:decimals];
                                               
                                           } andFailureHandler:^(NSError *error, NSString *message) {
                                               
                                               if (weakOperation.isCancelled) {
                                                   return;
                                               }
                                               
                                               if (weakSelf.delegateHandler) {
                                                   weakSelf.delegateHandler(NO);
                                               }
                                           }];

    }];
    
    [self.workingQueue addOperation:operation];
}

- (void)createHistoryElements:(NSDictionary *) responseObject withCurrency:(NSString*) currency withDecimals:(NSString*) decimals {
    
    NSBlockOperation* operation = [NSBlockOperation new];
    
    __weak __typeof (self) weakSelf = self;
    
    __weak NSBlockOperation *weakOperation = operation;
    
    [operation addExecutionBlock:^{
        
        if (weakOperation.isCancelled) {
            return;
        }
        
        NSMutableArray* history = @[].mutableCopy;

        for (NSDictionary *dictionary in responseObject) {
            id <HistoryElementProtocol> element = [self createHistoryElement:dictionary];
            [history addObject:element];
            element.currency = currency;
            [weakSelf.storageService createWalletContractHistoryEntityWith:element andDecimals:decimals];
        }
        
        [weakSelf.storageService saveWithcompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
            
            if (weakOperation.isCancelled) {
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.delegateHandler) {
                    weakSelf.delegateHandler(contextDidSave);
                }
            });
        }];
        
        [weakSelf checkRecieptForHistory:history];

    }];
    
    [self.workingQueue addOperation:operation];
}

- (void)createReceipt:(id) responseObject withTxHash:(NSString*) transactionHash {
    
    NSBlockOperation* operation = [NSBlockOperation new];
    
    __weak __typeof (self) weakSelf = self;
    
    __weak NSBlockOperation *weakOperation = operation;
    
    [operation addExecutionBlock:^{
        
        if (weakOperation.isCancelled) {
            return;
        }
        
        TransactionReceipt* receipt = [weakSelf.storageService createReceiptEntityWith:responseObject withTxHash:transactionHash];
        
        if (!receipt) {
            
            return;
        }
        
        [weakSelf.storageService updateHistoryEntityWithReceiptTxHash:receipt.transactionHash contracted:YES];
        [weakSelf.storageService saveWithcompletion:nil];
    }];
    
    [self.workingQueue addOperation:operation];
}

- (void)checkRecieptForHistory:(NSArray <HistoryElement *> *) history {
    
    __weak __typeof (self) weakSelf = self;
    
    for (HistoryElement* element in history) {
        
        if (![weakSelf.storageService findAllHistoryReceiptEntityWithTxHash:element.transactionHash].count && element.confirmed) {
            
            NSBlockOperation* operation = [NSBlockOperation new];
            
            __weak NSBlockOperation *weakOperation = operation;
            
            [operation addExecutionBlock:^{
                
                if (weakOperation.isCancelled) {
                    return;
                }
                
                NSString* transactionHash = element.transactionHash;
                [SLocator.requestManager getTransactionReceipt:transactionHash successHandler:^(id responseObject) {
                    
                    if (weakOperation.isCancelled) {
                        return;
                    }
                    
                    [weakSelf createReceipt:responseObject withTxHash:transactionHash];
                    
                } andFailureHandler:^(NSError *error, NSString *message) {
                    
                    if (weakOperation.isCancelled) {
                        return;
                    }
                }];
            }];
            
            [weakSelf.receiptUpdatingQueue addOperation:operation];
        }
    }
}

- (id <HistoryElementProtocol> )createHistoryElement:(NSDictionary *) dictionary {
    
    TokenHistoryElement *element = [TokenHistoryElement new];
    [element setupWithObject:dictionary];
    return element;
}

- (TransactionReceipt*)getRecieptWithTxHash:(NSString *) txHash {
    return [self.storageService findHistoryRecieptEntityWithTxHash:txHash];
}

-(void)clear {
    [self cancelOperations];
    self.delegateHandler = nil;
    self.totalItems = 0;
}

- (void)cancelOperations {
    
    [self.receiptUpdatingQueue cancelAllOperations];
    [self.workingQueue cancelAllOperations];
    self.delegateHandler = nil;
}

@end
