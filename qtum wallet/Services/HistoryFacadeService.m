//
//  HistoryFacadeService.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 01.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "HistoryFacadeService.h"
#import "WalletHistoryEntity+Extension.h"
#import "TransactionReceipt+Extension.h"
#import "RecieptLogDTO.h"

@interface HistoryFacadeService ()

@property (strong, nonatomic) id <Requestable> requestManager;
@property (strong, nonatomic) CoreDataService* storageService;
@property (copy, nonatomic) HistoryHendler delegateHandler;
@property (assign, nonatomic) NSInteger totalItems;
@property (strong, nonatomic) NSOperationQueue* receiptUpdatingQueue;
@property (strong, nonatomic) NSOperationQueue* workingQueue;

@end

static NSInteger batch = 25;

@implementation HistoryFacadeService

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

#pragma mark - Publick

- (void)updateHistroyForAddresses:(NSArray *) keyAddreses withPage:(NSInteger) page withHandler:(HistoryHendler) handler {

    __weak __typeof (self) weakSelf = self;

    NSBlockOperation* operation = [NSBlockOperation new];
    
    __weak NSBlockOperation *weakOperation = operation;

    [operation addExecutionBlock:^{
        
        if (weakOperation.isCancelled) {
            return;
        }
        
        NSDictionary* param = @{@"limit": @(batch), @"offset": @(page * batch)};
        weakSelf.delegateHandler = handler;
        
        [weakSelf.requestManager getHistoryWithParam:param andAddresses:keyAddreses successHandler:^(id responseObject, NSInteger totalCount) {
            
            if (weakOperation.isCancelled) {
                return;
            }
            
            weakSelf.totalItems = totalCount;
            [weakSelf createHistoryElements:responseObject];
            
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

- (void)updateHistoryElementWithTxHash:(NSString *) txHash withSuccessHandler:(void (^)(HistoryElement *historyItem)) success andFailureHandler:(void (^)(NSError *error, NSString *message)) failure {
    
    __weak typeof (self) weakSelf = self;
    
    [SLocator.requestManager infoAboutTransaction:txHash successHandler:^(id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            success ([weakSelf createHistoryElement:responseObject]);
        }
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure (error, message);
    }];
}

- (void)updateHistoryElementWithDict:(NSDictionary *) dataDictionary {
    
    NSBlockOperation* operation = [NSBlockOperation new];
    
    __weak __typeof (self) weakSelf = self;
    
    __weak NSBlockOperation *weakOperation = operation;
    
    [operation addExecutionBlock:^{
        
        if (weakOperation.isCancelled) {
            return;
        }
        
        HistoryElement *element = [weakSelf createHistoryElement:dataDictionary];
        
        [weakSelf.storageService createWalletHistoryEntityWith:element];
        
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
        
        if (weakOperation.isCancelled) {
            return;
        }
        
        [weakSelf checkRecieptForHistory:@[element]];
        [SLocator.contractManager checkSmartContractPretendents];
    }];
    
    [self.workingQueue addOperation:operation];
}

- (void)createHistoryElements:(NSArray *) responseObject {
    
    NSBlockOperation* operation = [NSBlockOperation new];
    
    __weak __typeof (self) weakSelf = self;

    __weak NSBlockOperation *weakOperation = operation;
    
    [operation addExecutionBlock:^{
        
        if (weakOperation.isCancelled) {
            return;
        }
        
        NSArray *responseObjectLocal = [[responseObject reverseObjectEnumerator] allObjects];
        NSMutableArray* history = @[].mutableCopy;
        
        for (NSDictionary *dictionary in responseObjectLocal) {
            
            if (weakOperation.isCancelled) {
                return;
            }
            
            HistoryElement *element = [weakSelf createHistoryElement:dictionary];
            [history addObject:element];
            
            [weakSelf.storageService createWalletHistoryEntityWith:element];
        }
        
        if (history.count == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.delegateHandler) {
                    weakSelf.delegateHandler(YES);
                }
            });
            return;
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
        
        if (weakOperation.isCancelled) {
            return;
        }
        
        [weakSelf checkRecieptForHistory:history];
        [SLocator.contractManager checkSmartContractPretendents];
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
        
        [weakSelf.storageService updateHistoryEntityWithReceiptTxHash:receipt.transactionHash contracted:receipt.contractAddress ? YES : NO];
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

- (HistoryElement *)createHistoryElement:(NSDictionary *) dictionary {
    
    
    HistoryElement *element = [HistoryElement new];
    [element setupWithObject:dictionary];
    [SLocator.contractManager checkSmartContract:element];
    return element;
}

- (NSArray<RecieptLogDTO*>*)getLogsDTOSWithReceit:(TransactionReceipt *) receipt {

    NSMutableArray<RecieptLogDTO*>* dtos = @[].mutableCopy;
    
    for (Log* log in receipt.logs.allObjects) {
        RecieptLogDTO* dto = [[RecieptLogDTO alloc] initWithLog:log];
        [dtos addObject:dto];
    }
    
    return dtos;
}

- (TransactionReceipt*)getRecieptWithTxHash:(NSString *) txHash {
    return [self.storageService findHistoryRecieptEntityWithTxHash:txHash];
}

- (NSArray<WalletHistoryEntity*>*)historyForWatch {
    return [self.storageService allWalletHistoryEntitysWithLimit:batch];
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
