//
//  NetworkingService.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RequestType){
    POST,
    GET,
    DELETE,
    PUT
};

@interface NetworkingService : NSObject

- (instancetype _Nullable )initWithBaseUrl:(NSString*_Nonnull)baseUrl;

- (void)requestWithType:(RequestType) type
                  path:(NSString*_Nonnull) path
             andParams:(NSDictionary*_Nullable) param
    withSuccessHandler:(void(^_Nullable)(id  _Nonnull responseObject)) success
     andFailureHandler:(void(^_Nullable)(NSError * _Nonnull error, NSString* _Nullable message)) failure;

@end
