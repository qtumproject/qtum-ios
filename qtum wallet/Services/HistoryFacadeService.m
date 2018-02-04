//
//  HistoryFacadeService.m
//  qtum wallet
//
//  Created by Fedorenko Nikita on 01.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "HistoryFacadeService.h"
#import "WalletHistoryEntity+Extension.h"

@interface HistoryFacadeService ()

@property (strong, nonatomic) id <Requestable> requestManager;
@property (strong, nonatomic) CoreDataService* storageService;
@property (copy, nonatomic) HistoryHendler handler;
@property (assign, nonatomic) NSInteger totalItems;

@end

static NSInteger batch = 25;

@implementation HistoryFacadeService

- (instancetype)initWithRequestService:(id <Requestable>) requestManager andStorageService:(CoreDataService*) storageService {
    
    self = [super init];
    
    if (self) {
        _requestManager = requestManager;
        _storageService = storageService;
    }
    return self;
}

#pragma mark - Publick

- (void)updateHistroyForAddresses:(NSArray *) keyAddreses withPage:(NSInteger) page withHandler:(HistoryHendler) handler {

    NSDictionary* param = @{@"limit": @(batch), @"offset": @(page * batch)};
    __weak typeof (self) weakSelf = self;
    self.handler = handler;
    
    [self.requestManager getHistoryWithParam:param andAddresses:keyAddreses successHandler:^(id responseObject, NSInteger totalCount) {
        
        weakSelf.totalItems = totalCount;
        [weakSelf createHistoryElements:responseObject];
    } andFailureHandler:^(NSError *error, NSString *message) {
        
        if (weakSelf.handler) {
            weakSelf.handler(NO);
            weakSelf.handler = nil;
        }
    }];
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

- (void)createHistoryElements:(NSArray *) responseObject {
    
    NSArray *responseObjectLocal = [[responseObject reverseObjectEnumerator] allObjects];
    
    for (NSDictionary *dictionary in responseObjectLocal) {
        
        HistoryElement *element = [self createHistoryElement:dictionary];
        
        [self.storageService createWalletHistoryEntityWith:element];
    }
    __weak typeof (self) weakSelf = self;

    [self.storageService saveWithcompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
        if (weakSelf.handler) {
            weakSelf.handler(contextDidSave);
            weakSelf.handler = nil;
        }
    }];
    
    [SLocator.contractManager checkSmartContractPretendents];    
}

- (void)checkRecieptForHistory:(NSArray <HistoryElement *> *) history {
    
    for (HistoryElement* element in history) {
        
        [SLocator.requestManager getTransactionReceipt:element.txHash successHandler:^(id responseObject) {
            
        } andFailureHandler:^(NSError *error, NSString *message) {
            
        }];
    }
}

- (HistoryElement *)createHistoryElement:(NSDictionary *) dictionary {
    
    HistoryElement *element = [HistoryElement new];
    [element setupWithObject:dictionary];
    [SLocator.contractManager checkSmartContract:element];
    return element;
}


@end
