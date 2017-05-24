//
//  RPCRequestManager.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 16.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "RPCRequestManager.h"
#import <AFJSONRPCClient/AFJSONRPCClient.h>
#import "RPCAdapter.h"

NSString *const BASE_URL_RPC = @"http://user:pw@139.162.49.60:22822/";
//NSString *const BASE_URL_RPC = @"http://user:pw@s.pixelplex.by:22822/";

@interface RPCRequestManager ()

@property (strong, nonatomic) AFJSONRPCClient *client;
@property (strong,nonatomic) id <RequestManagerAdapter> adapter;

@end

@implementation RPCRequestManager

+ (instancetype)sharedInstance
{
    static RPCRequestManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[super alloc] initUniqueInstance];
    });
    return manager;
}

- (instancetype)initUniqueInstance
{
    self = [super init];
    
    if (self != nil) {
        _adapter = [RPCAdapter new];
    }
    
    return self;
}

- (AFJSONRPCClient *)client
{
    if (!_client) {
        AFJSONRPCClient *client = [AFJSONRPCClient clientWithEndpointURL:[NSURL URLWithString:BASE_URL_RPC]];
        _client = client;
    }
    return _client;
}

#pragma mark -

-(void)invokeMethod:(NSString *)method andParams:(id)params withSuccessHandler:(void(^)(id responseObject))success andFailureHandler:(void(^)(NSError *error, NSString* message)) failure
{
    [self.client invokeMethod:method withParameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error, nil);
    }];
}

-(void)invokeMethod:(NSString *)method  withSuccessHandler:(void(^)(id responseObject)) success andFailureHandler:(void(^)(NSError *error, NSString* message))failure
{
    [self.client invokeMethod:method success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error, nil);
    }];
}

#pragma mark - Methods

- (void)registerKey:(NSString *)keyString identifier:(NSString *)identifier new:(BOOL)new withSuccessHandler:(void(^)(id responseObject))success andFailureHandler:(void(^)(NSError * error, NSString* message))failure
{
    NSString *method = @"importaddress";
    BOOL needResearchInBlockChain = !new;
    BOOL lastParameter = NO;
    
    NSArray *params = @[keyString, identifier, @(needResearchInBlockChain), @(lastParameter)];
    [self invokeMethod:method andParams:params withSuccessHandler:^(id responseObject) {
        success(responseObject);
    } andFailureHandler:^(NSError *error, NSString *message) {
        if ([error.localizedDescription isEqualToString:@"Unknown JSON-RPC Response"]) {
            success(nil);
        }else{
            failure(error, message);
        }
    }];
}

- (void)registerKey:(NSString *)keyString new:(BOOL)new withSuccessHandler:(void(^)(id responseObject))success andFailureHandler:(void(^)(NSError * error, NSString* message))failure
{
    NSString *identifier = @"Some new identitfier";
    
    [self registerKey:keyString identifier:identifier new:new withSuccessHandler:^(id responseObject) {
        success(responseObject);
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(error, message);
    }];
}

- (void)getUnspentOutputsForAdreses:(NSArray*) addresses
                         isAdaptive:(BOOL) adaptive
                     successHandler:(void(^)(id responseObject))success
                  andFailureHandler:(void(^)(NSError * error, NSString* message))failure{
    NSString *method = @"listunspent";
    NSNumber *firt = @(0);
    NSNumber *last = @(20000);
    __weak __typeof(self)weakSelf = self;
    NSArray *params = @[firt, last, addresses];
    [self invokeMethod:method andParams:params withSuccessHandler:^(id responseObject) {
        responseObject = adaptive ? [weakSelf.adapter adaptiveDataForOutputs:responseObject] : responseObject;
        success(responseObject);
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(error, message);
    }];
}

- (void)sendTransaction:(NSString *)transactionHexString withSuccessHandler:(void(^)(id responseObject))success andFailureHandler:(void(^)(NSError * error, NSString* message))failure
{
    NSLog(@"Hex : %@", transactionHexString);
    NSString *method = @"sendrawtransaction";
    BOOL allowhighfees = YES;
    
    NSArray *params = @[transactionHexString, @(allowhighfees)];
    [self invokeMethod:method andParams:params withSuccessHandler:^(id responseObject) {
        success(responseObject);
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(error, message);
    }];
}

- (void)sendTransactionWithParam:(NSDictionary *)param
     withSuccessHandler:(void(^)(id responseObject))success
      andFailureHandler:(void(^)(NSString* message)) failure{
    
    NSLog(@"Hex : %@", param[@"data"]);
    NSString *method = @"sendrawtransaction";
    BOOL allowhighfees = YES;
    
    NSArray *params = @[param[@"data"], @(allowhighfees)];
    [self invokeMethod:method andParams:params withSuccessHandler:^(id responseObject) {
        success(responseObject);
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure( message);
    }];
}


- (void)getInfoWithSuccessHandler:(void(^)(id responseObject))success andFailureHandler:(void(^)(NSError *error, NSString* message))failure
{
    NSString *method = @"getinfo";
    
    [self invokeMethod:method withSuccessHandler:^(id responseObject) {
        success(responseObject);
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(error, message);
    }];
}

- (void)sendToAddress:(NSString *)key withSuccessHandler:(void(^)(id responseObject))success andFailureHandler:(void(^)(NSError * error, NSString* message))failure
{
    NSString *method = @"sendtoaddress";
    NSNumber *count = @(arc4random() % 20);
    
    NSArray *params = @[key, count];
    [self invokeMethod:method andParams:params withSuccessHandler:^(id responseObject) {
        success(responseObject);
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(error, message);
    }];
}

- (void)generate:(void(^)(id responseObject))success andFailureHandler:(void(^)(NSError * error, NSString* message))failure
{
    NSString *method = @"generate";
    NSNumber *count = @(1);
    
    NSArray *params = @[count];
    [self invokeMethod:method andParams:params withSuccessHandler:^(id responseObject) {
        success(responseObject);
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(error, message);
    }];
}

- (void)getHistoryWithParam:(NSDictionary*) param
               andAddresses:(NSArray*) addresses
             successHandler:(void(^)(id responseObject))success
          andFailureHandler:(void(^)(NSError * error, NSString* message))failure{
    
    NSString *method = @"listtransactions";
    NSNumber *count = @(10000000);;
    NSNumber *someValue = @(0);
    NSNumber *flag = @YES;
    NSArray *params = @[[[WalletManager sharedInstance]getCurrentWallet].getWorldsString, count, someValue, flag];
    __weak __typeof(self)weakSelf = self;
    
    [self invokeMethod:method andParams:params withSuccessHandler:^(id responseObject) {
        responseObject = [weakSelf.adapter adaptiveDataForHistory:responseObject];
        success(responseObject);
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(error, message);
    }];
}

- (void)getNews:(void(^)(id responseObject))success andFailureHandler:(void(^)(NSError * error, NSString* message))failure{
    success(nil);
}

- (void)getBlockchainInfo:(void(^)(id responseObject))success andFailureHandler:(void(^)(NSError * error, NSString* message))failure{
    success(nil);
}

#pragma mark - BitCode

- (void)generateTokenBitcodeWithDict:(NSDictionary *) param
                  withSuccessHandler:(void(^)(id responseObject))success
                   andFailureHandler:(void(^)(NSError * error, NSString* message))failure{
    
    failure(nil, nil);
}

- (void)callFunctionToContractAddress:(NSString*) address
                           withHashes:(NSArray*) hashes
                          withHandler:(void(^)(id responseObject))completesion {
    completesion(nil);
}

- (void)getTokenInfoWithDict:(NSDictionary*) dict
          withSuccessHandler:(void(^)(id responseObject))success
           andFailureHandler:(void(^)(NSError * error, NSString* message))failure{
    failure([NSError new], @"You cant use token from RPC");
}

#pragma mark - Observing Socket


- (void)startObservingAdresses:(NSArray*) addresses{
    
}

- (void)stopObservingAdresses:(NSArray*) addresses{
    
}

@end
