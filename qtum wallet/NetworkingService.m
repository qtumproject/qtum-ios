//
//  NetworkingService.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NetworkingService.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonHMAC.h>

@interface NetworkingService ()

@property (copy, nonatomic) NSString* baseUrl;
@property (strong,nonatomic)AFHTTPRequestOperationManager* requestManager;

@end

@implementation NetworkingService

@synthesize accesToken;

- (instancetype)initWithBaseUrl:(NSString*)baseUrl {
    
    self = [super init];
    if (self) {
        [self networkMonitoring];
        _baseUrl = baseUrl;
    }
    return self;
}

- (AFHTTPRequestOperationManager *)requestManager {
    
    if (!_requestManager) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:self.baseUrl]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer =  [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
        
        if (accesToken) {
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", accesToken] forHTTPHeaderField:@"Authorization"];
        }

        [manager.requestSerializer setTimeoutInterval:15];
        _requestManager = manager;
    }
    return _requestManager;
}

- (void)networkMonitoring {
    
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
            failure(error,NO_INTERNET_CONNECTION_ERROR_KEY);
            [[NSNotificationCenter defaultCenter] postNotificationName:NO_INTERNET_CONNECTION_ERROR_KEY object:nil];
        }
        else {
            failure(error,@"This action can not be performed");
        }
    }else {
        failure(error,@"This action can not be performed");
    }
}

@end
