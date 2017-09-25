//
//  QStoreContractDownloadManager.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 22.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QStoreContractDownloadManager.h"
#import "TemplateManager.h"

@interface QStoreContractDownloadManager ()

@property (strong, nonatomic) QStoreDataProvider* dataProvider;
@property (nonatomic, strong) NSOperationQueue* requestQueue;

@end

@implementation QStoreContractDownloadManager

- (instancetype)initWithDataProvider:(QStoreDataProvider*) dataProvider {
    
    self = [super init];
    if (self) {
        _dataProvider = dataProvider;
        _requestQueue = [[NSOperationQueue alloc] init];
        _requestQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

-(void)downloadContractWithRequest:(QStoreBuyRequest*) request completion:(void(^)(BOOL success, QStoreBuyRequest *request)) completion {
    
    void(^completionCopy)() = [completion copy];
    __weak __typeof(self)weakSelf = self;
    
    dispatch_block_t block = ^{
        
        DLog(@"START");

        NSString* __block abi;
        NSString* __block source;
        NSString* __block bitecode;

        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        dispatch_group_t downloadGoup = dispatch_group_create();
        
        dispatch_group_enter(downloadGoup);
        
        [weakSelf.dataProvider getContractABI:request.contractId withSuccessHandler:^(NSString *abiString) {
            abi = abiString;
            dispatch_group_leave(downloadGoup);
        } andFailureHandler:^(NSError *error, NSString *message) {
            dispatch_group_leave(downloadGoup);
        }];
        
        dispatch_group_enter(downloadGoup);
        
        [weakSelf.dataProvider getSourceCode:request.contractId requestId:request.requestId accessToken:request.accessToken withSuccessHandler:^(NSString *sourceCode) {
            source = sourceCode;
            dispatch_group_leave(downloadGoup);
        } andFailureHandler:^(NSError *error, NSString *message) {
            dispatch_group_leave(downloadGoup);
        }];
        
        dispatch_group_enter(downloadGoup);
        
        [weakSelf.dataProvider getByteCode:request.contractId requestId:request.requestId accessToken:request.accessToken withSuccessHandler:^(NSString *aBitecode) {
            bitecode = aBitecode;
            dispatch_group_leave(downloadGoup);
        } andFailureHandler:^(NSError *error, NSString *message) {
            dispatch_group_leave(downloadGoup);
        }];

        
        dispatch_group_notify(downloadGoup, dispatch_get_main_queue(),^{
            dispatch_semaphore_signal(semaphore);
        });
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        DLog(@"Abi------>%@", abi);
        DLog(@"Source------>%@", source);
        
        DLog(@"END");
        
        BOOL result = [weakSelf writeContractWith:abi source:source withBiteCode:bitecode withName:request.templateName withUUID:request.contractId withStringType:request.templateType];
        
        completionCopy(result, request);
    };
    
    [_requestQueue addOperationWithBlock:block];
}

-(BOOL)writeContractWith:(NSString*) abi
                  source:(NSString*) source
            withBiteCode:(NSString*) biteCode
                withName:(NSString*) name
                withUUID:(NSString*) uuid
          withStringType:(TemplateType) type {
    
    if (abi && source && biteCode) {
        
        return [[TemplateManager sharedInstance] createNewTemplateWithAbi:abi bitecode:biteCode source:source type:type uuid:uuid andName:name];
    }
    
    return NO;
}

@end
