//
//  TCARequestManager.m
//  TCA2016
//
//  Created by Nikita on 09.08.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "AFNetworking.h"
#import "RequestManager.h"
#import <CommonCrypto/CommonHMAC.h>

typedef NS_ENUM(NSInteger, RequestType){
    POST,
    GET,
    DELETE,
    PUT
};

NSString *const BASE_URL = @"http://85.90.245.184/";

@interface RequestManager()

@property (strong,nonatomic)AFHTTPRequestOperationManager* requestManager;

@end

@implementation RequestManager

+ (instancetype)sharedInstance
{
    static RequestManager *manager;
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
        [self networkMonitoring];
    }

    return self;
}


#pragma mark - Setup and Privat Methods


- (AFHTTPRequestOperationManager *)requestManager
{
    if (!_requestManager) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setTimeoutInterval:15];
        _requestManager = manager;
    }
    return _requestManager;
}

- (void)networkMonitoring
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusReachableViaWiFi ||
            status == AFNetworkReachabilityStatusReachableViaWWAN) {
        }
    }];
    [manager startMonitoring];
}

-(void)requestWithType:(RequestType) type path:(NSString*) path andParams:(NSDictionary*) param withSuccessHandler:(void(^)(id  _Nonnull responseObject)) success andFailureHandler:(void(^)(NSError * _Nonnull error, NSString* message)) failure
{
    if (type == POST) {
        [self.requestManager POST:path parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            success(responseObject);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            if (operation.response.statusCode == 200) {
                success(@"");
            }else {
                [self handingErrorsWithOperation:operation andEror:error withSuccessHandler:success andFailureHandler:failure];
            }
        }];
    }
    else if(type == GET){
        [self.requestManager GET:path parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            success(responseObject);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            [self handingErrorsWithOperation:operation andEror:error withSuccessHandler:success andFailureHandler:failure];
        }];
    }
    else if(type == DELETE){
        [self.requestManager DELETE:path parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            success(responseObject);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            [self handingErrorsWithOperation:operation andEror:error withSuccessHandler:success andFailureHandler:failure];
        }];
    }
    else if(type == PUT){
        [self.requestManager PUT:path parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
            success(responseObject);
        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
            [self handingErrorsWithOperation:operation andEror:error withSuccessHandler:success andFailureHandler:failure];
        }];
    }
}

-(void)handingErrorsWithOperation:(AFHTTPRequestOperation * _Nullable) operation andEror:(NSError * _Nonnull) error withSuccessHandler:(void(^)(id  _Nonnull responseObject)) success andFailureHandler:(void(^)(NSError * _Nonnull error, NSString* message)) failure{
    
    NSString* message = ([operation.responseObject isKindOfClass:[NSDictionary class]]) ? operation.responseObject[@"message"] : operation.responseObject[0][@"message"];
    if (message) {
        failure(error,message);
    }else if (!operation.response){
        if (!self.requestManager.reachabilityManager.isReachable) {
            failure(error,@"No Internet Connection Found");
        }
        else {
            failure(error,@"This action can not be performed");
        }
    }else {
        failure(error,@"This action can not be performed");
    }
}


#pragma mark - Methods


-(void)getBalanceByKey:(NSString *)publicKey withSuccessHandler:(void(^)(id responseObject)) success andFailureHandler:(void(^)(NSString* message)) failure
{
    NSString *path = [NSString stringWithFormat:@"ext/getbalance/%@", publicKey];
    [self requestWithType:GET path:path andParams:nil withSuccessHandler:^(id  _Nonnull responseObject) {
        success(responseObject);
        NSLog(@"Succes");
        
    } andFailureHandler:^(NSError * _Nonnull error, NSString* message) {
        failure(message);
        NSLog(@"Failure");
    }];
}

- (void)sendTransaction:(NSDictionary *)dictionary withSuccessHandler:(void(^)(id responseObject)) success andFailureHandler:(void(^)(NSString* message)) failure
{
    [self requestWithType:GET path:@"" andParams:dictionary withSuccessHandler:^(id  _Nonnull responseObject) {
        success(responseObject);
        NSLog(@"Succes");
        
    } andFailureHandler:^(NSError * _Nonnull error, NSString* message) {
        failure(message);
        NSLog(@"Failure");
    }];
}

@end
