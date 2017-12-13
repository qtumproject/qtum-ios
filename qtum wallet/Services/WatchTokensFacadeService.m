//
//  WatchTokensFacadeService.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 24.11.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "WatchTokensFacadeService.h"

@interface WatchTokensFacadeService()

@property (nonatomic, strong) NSOperationQueue *workingQueue;
@property (nonatomic, copy) WatchTokenName completion;

@end

@implementation WatchTokensFacadeService

- (instancetype)init {
    
    self = [super init];
    if (self) {
        _workingQueue = [[NSOperationQueue alloc] init];
        _workingQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

#pragma mark - Public Methods

-(void)getTokenNameWithAddress:(NSString *) address withHandler:(WatchTokenName) handler {
    
    if (![SLocator.validationInputService isValidContractAddressString:address]) {
        return;
    }
    
    [self cancelAllPreviusOperation];
    
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    
    __weak NSBlockOperation *weakOperation = operation;
    __weak __typeof(self) weakSelf = self;
    
    [operation addExecutionBlock:^{
        
        if (weakOperation.isCancelled) {
            return;
        }
        
        [SLocator.requestManager tokenInfoWithAddress:address withSuccessHandler:^(id responseObject) {
            
            if (!weakOperation.isCancelled) {
                NSString* name = responseObject[@"name"];
                weakSelf.completion(name, nil);
            }
            
        } andFailureHandler:^(NSError *error, NSString *message) {
            
            if (!weakOperation.isCancelled) {
                weakSelf.completion(nil, error);
            }
        }];
    }];
    
    self.completion = handler;
    [self.workingQueue addOperation:operation];
}


- (BOOL)createTokenWithTokenName:(NSString*) name andAddress:(NSString*) address andErrorString:(NSString **) errorString {
    
    if (![SLocator.validationInputService isValidContractAddressString:address]) {
        
        *errorString = NSLocalizedString(@"Invalid Token Address", nil);
        return NO;
    }
    
    return [SLocator.contractManager addNewTokenWithContractAddress:address andWithName:name errorString:errorString];
}

#pragma mark - Private Methods

-(void)cancelAllPreviusOperation {
    
    [self.workingQueue cancelAllOperations];
}
@end
