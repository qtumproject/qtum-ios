//
//  RPCRequestManager.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 16.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "RPCRequestManager.h"
#import <AFJSONRPCClient/AFJSONRPCClient.h>
#import "KeysManager.h"

//NSString *const BASE_URL_RPC = @"http://user:pw@192.168.1.55:22822/";
NSString *const BASE_URL_RPC = @"http://user:pw@s.pixelplex.by:22822/";
NSString *const BASE_LABEL = @"qtum_mobile_wallet_1";

@interface RPCRequestManager ()

@property (strong, nonatomic) AFJSONRPCClient *client;

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

- (void)registerKey:(NSString *)keyString new:(BOOL)new withSuccessHandler:(void(^)(id responseObject))success andFailureHandler:(void(^)(NSError * error, NSString* message))failure
{
    NSString *method = @"importaddress";
    NSString *identifier = [KeysManager sharedInstance].label;
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

- (void)getListUnspentForKeys:(NSArray *)keys withSuccessHandler:(void(^)(id responseObject))success andFailureHandler:(void(^)(NSError *error, NSString* message))failure
{
    NSString *method = @"listunspent";
    NSNumber *firt = @(0);
    NSNumber *last = @(20000);
    
    NSArray *params = @[firt, last, keys];
    [self invokeMethod:method andParams:params withSuccessHandler:^(id responseObject) {
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
    NSNumber *count = @(20);
    
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

- (void)getHistory:(void(^)(id responseObject))success andFailureHandler:(void(^)(NSError * error, NSString* message))failure
{
    NSString *method = @"listtransactions";
    NSNumber *count = @(10000000);
    NSNumber *someValue = @(0);
    NSNumber *flag = [NSNumber numberWithBool:true];
    
    NSArray *params = @[[KeysManager sharedInstance].label, count, someValue, flag];
    [self invokeMethod:method andParams:params withSuccessHandler:^(id responseObject) {
        success(responseObject);
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(error, message);
    }];
}

@end
