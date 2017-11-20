//
//  NetworkOAuth2Service.m
//  qtum wallet
//
//  Created by Никита Федоренко on 16.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NetworkOAuth2Service.h"
#import "AFNetworking.h"
#import <CommonCrypto/CommonHMAC.h>

@interface NetworkOAuth2Service()

@property (copy, nonatomic) NSString* baseUrl;
@property (strong,nonatomic)AFHTTPRequestOperationManager* requestManager;

@end

@implementation NetworkOAuth2Service

- (instancetype)initWithBaseUrl:(NSString*)baseUrl {
    
    self = [super init];
    if (self) {
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
        
        [manager.requestSerializer setTimeoutInterval:15];
        _requestManager = manager;
    }
    return _requestManager;
}

-(void)requestWithType:(RequestType) type path:(NSString*) path andParams:(NSDictionary*) param withSuccessHandler:(void(^)(id  _Nonnull responseObject)) success andFailureHandler:(void(^)(NSError * _Nonnull error, NSString* message)) failure {
    
//    if (type == POST) {
//        [self.requestManager POST:path parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//            success(responseObject);
//        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//            if (operation.response.statusCode == 200) {
//                success(@"");
//            }else {
//                [self handingErrorsWithOperation:operation andEror:error withSuccessHandler:success andFailureHandler:failure];
//            }
//        }];
//    }
//    else if(type == GET){
//        [self.requestManager GET:path parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//            success(responseObject);
//        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//            [self handingErrorsWithOperation:operation andEror:error withSuccessHandler:success andFailureHandler:failure];
//        }];
//    }
//    else if(type == DELETE){
//        [self.requestManager DELETE:path parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//            success(responseObject);
//        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//            [self handingErrorsWithOperation:operation andEror:error withSuccessHandler:success andFailureHandler:failure];
//        }];
//    }
//    else if(type == PUT){
//        [self.requestManager PUT:path parameters:param success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//            success(responseObject);
//        } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//            [self handingErrorsWithOperation:operation andEror:error withSuccessHandler:success andFailureHandler:failure];
//        }];
//    }
}

@end
