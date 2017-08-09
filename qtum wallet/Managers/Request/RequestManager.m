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
#import "ServerAdapter.h"
#import "SocketManager.h"
#import "Wallet.h"

typedef NS_ENUM(NSInteger, RequestType){
    POST,
    GET,
    DELETE,
    PUT
};

NSString *const BASE_URL = @"http://163.172.68.103:5931";
//NSString *const BASE_URL = @"http://163.172.68.103:5931";

@interface RequestManager()

@property (strong,nonatomic)AFHTTPRequestOperationManager* requestManager;
@property (strong,nonatomic) id <RequestManagerAdapter> adapter;
@property (strong,nonatomic) SocketManager *socketManager;

@end

@implementation RequestManager

+ (instancetype)sharedInstance {
    
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
        _adapter = [ServerAdapter new];
    }

    return self;
}


#pragma mark - Setup and Privat Methods


- (AFHTTPRequestOperationManager *)requestManager {
    
    if (!_requestManager) {
        AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer =  [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
       
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

-(SocketManager *)socketManager {
    
    if (!_socketManager) {
        _socketManager = [SocketManager new];
        _socketManager.delegate = self;
    }
    return _socketManager;
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


#pragma mark - Methods


- (void)registerKey:(NSString *)keyString
         identifier:(NSString *)identifier new:(BOOL)new
 withSuccessHandler:(void(^)(id responseObject))success
  andFailureHandler:(void(^)(NSError * error, NSString* message))failure{
    
    
    success(nil);
    
    
}

- (void)registerKey:(NSString *)keyString
                new:(BOOL)new withSuccessHandler:(void(^)(id responseObject))success
  andFailureHandler:(void(^)(NSError *error, NSString* message))failure{
    success(nil);
}

- (void)sendToAddress:(NSString *)key
   withSuccessHandler:(void(^)(id responseObject))success
    andFailureHandler:(void(^)(NSError * error, NSString* message))failure{
    success(nil);
}

#pragma mark - Send Transactions

- (void)sendTransactionWithParam:(NSDictionary *)param
              withSuccessHandler:(void(^)(id responseObject))success
               andFailureHandler:(void(^)(NSString* message)) failure{
    
    [self requestWithType:POST path:@"send-raw-transaction" andParams:param withSuccessHandler:^(id  _Nonnull responseObject) {
        success(responseObject);
    } andFailureHandler:^(NSError * _Nonnull error, NSString *message) {
        failure(message);
    }];
}


- (void)getUnspentOutputsForAdreses:(NSArray*) addresses
                         isAdaptive:(BOOL) adaptive
                     successHandler:(void(^)(id responseObject))success
                  andFailureHandler:(void(^)(NSError * error, NSString* message))failure{
    
    NSMutableDictionary* param;
    NSString* pathString;
    __weak __typeof(self)weakSelf = self;
    
    if (addresses.count == 1) {
        pathString = [NSString stringWithFormat:@"outputs/unspent/%@",addresses[0]];
    } else {
        pathString = @"outputs/unspent";
        param = @{}.mutableCopy;
        param[@"addresses[]"] = addresses;
    }
    
    [self requestWithType:GET path:pathString andParams:param withSuccessHandler:^(id  _Nonnull responseObject) {
        
        id adaptiveResponse = adaptive ? [weakSelf.adapter adaptiveDataForOutputs:responseObject] : responseObject;
        success(adaptiveResponse);
        DLog(@"Succes");
    } andFailureHandler:^(NSError * _Nonnull error, NSString* message) {
        failure(error,message);
        DLog(@"Failure");
    }];
}

#pragma mark - News

- (void)getNews:(void(^)(id responseObject))success andFailureHandler:(void(^)(NSError * error, NSString* message))failure{
    
    [self requestWithType:GET path:@"news/en" andParams:nil withSuccessHandler:^(id  _Nonnull responseObject) {
        success(responseObject);
        DLog(@"Succes");
        
    } andFailureHandler:^(NSError * _Nonnull error, NSString* message) {
        failure(error,message);
        DLog(@"Failure");
    }];
}

#pragma mark - History

- (void)getHistoryWithParam:(NSDictionary*) param
               andAddresses:(NSArray*) addresses
             successHandler:(void(^)(id responseObject))success
          andFailureHandler:(void(^)(NSError * error, NSString* message))failure{

    NSMutableDictionary* adressesForParam;
    NSString* pathString;
    __weak __typeof(self)weakSelf = self;
    if (addresses) {
        pathString = [NSString stringWithFormat:@"%@/%@/%@",@"history",param[@"limit"],param[@"offset"]];
        adressesForParam = @{}.mutableCopy;
        adressesForParam[@"addresses[]"] = addresses;
    }else {
        pathString = [NSString stringWithFormat:@"%@/%@/%@/%@",@"history",param[@"address"],param[@"limit"],param[@"offset"]];
    }

    [self requestWithType:GET path:pathString andParams:adressesForParam withSuccessHandler:^(id  _Nonnull responseObject) {
        __block id response = responseObject;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            response = [weakSelf.adapter adaptiveDataForHistory:response];
            success(response);
            DLog(@"Succes");
        });

    } andFailureHandler:^(NSError * _Nonnull error, NSString* message) {
        failure(error,message);
        DLog(@"Failure");
    }];
}

- (void)infoAboutTransaction:(NSString*) txhash
              successHandler:(void(^)(id responseObject))success
           andFailureHandler:(void(^)(NSError * error, NSString* message))failure {
    
    NSString* pathString = [NSString stringWithFormat:@"%@/%@",@"transactions",txhash];
    __weak __typeof(self)weakSelf = self;

    [self requestWithType:GET path:pathString andParams:nil withSuccessHandler:^(id  _Nonnull responseObject) {
        __block id response = responseObject;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            success(response);
            DLog(@"Succes");
        });
        
    } andFailureHandler:^(NSError * _Nonnull error, NSString* message) {
        failure(error,message);
        DLog(@"Failure");
    }];
}


#pragma mark - Info

- (void)getBlockchainInfo:(void(^)(id responseObject))success andFailureHandler:(void(^)(NSError * error, NSString* message))failure{
    [self requestWithType:GET path:@"blockchain/info" andParams:nil withSuccessHandler:^(id  _Nonnull responseObject) {
        success(responseObject);
        DLog(@"Succes");
    } andFailureHandler:^(NSError * _Nonnull error, NSString* message) {
        failure(error,message);
        DLog(@"Failure");
    }];
}

#pragma mark - BitCode

- (void)generateTokenBitcodeWithDict:(NSDictionary *) param
                  withSuccessHandler:(void(^)(id responseObject))success
                   andFailureHandler:(void(^)(NSError * error, NSString* message))failure{
    
    [self requestWithType:POST path:@"contracts/generate-token-bytecode" andParams:param withSuccessHandler:^(id  _Nonnull responseObject) {
        success(responseObject);
    } andFailureHandler:^(NSError * _Nonnull error, NSString *message) {
        failure(error, message);
    }];
}

- (void)callFunctionToContractAddress:(NSString*) address
                           withHashes:(NSArray*) hashes
                          withHandler:(void(^)(id responseObject))completesion {

    NSString* pathString = [NSString stringWithFormat:@"/contracts/%@/call",address];


    [self requestWithType:POST path:pathString andParams:@{@"hashes" : hashes} withSuccessHandler:^(id  _Nonnull responseObject) {
        completesion(responseObject);
    } andFailureHandler:^(NSError * _Nonnull error, NSString *message) {
        completesion(error);
    }];
}

#pragma mark - Token 

- (void)tokenInfoWithDict:(NSDictionary*) dict
          withSuccessHandler:(void(^)(id responseObject))success
           andFailureHandler:(void(^)(NSError * error, NSString* message))failure{
    NSString* path = [NSString stringWithFormat:@"contracts/%@/params?keys=symbol,decimals,name,totalSupply",dict[@"addressContract"]];
    
    [self requestWithType:GET path:path andParams:nil withSuccessHandler:^(id  _Nonnull responseObject) {
        success(responseObject);
    } andFailureHandler:^(NSError * _Nonnull error, NSString *message) {
        failure(error, message);
    }];
}

#pragma mark - Observing Socket


- (void)startObservingAdresses:(NSArray*) addresses {
    
    [self.socketManager subscripeToUpdateWalletAdresses:[[ApplicationCoordinator sharedInstance].walletManager wallet].allKeysAdreeses];
}

- (void)stopObservingAdresses:(NSArray*) addresses {
    
    [self.socketManager stoptWithHandler:nil];
}

- (void)startObservingForToken:(Contract*) token withHandler:(void(^)(id responseObject))completesion {
    [self.socketManager startObservingToken:token withHandler:completesion];
}

- (void)stopObservingForToken:(Contract*) token {
    [self.socketManager stopObservingToken:token withHandler:nil];
}

#pragma mark - QStore

- (void)getContractsByCategoryPath:(NSString *)path withSuccessHandler:(void(^)(id responseObject))success
        andFailureHandler:(void(^)(NSError * error, NSString* message))failure {
    
    [self requestWithType:GET path:path andParams:nil withSuccessHandler:^(id  _Nonnull responseObject) {
        success(responseObject);
    } andFailureHandler:^(NSError * _Nonnull error, NSString *message) {
        failure(error, message);
    }];
}

- (void)getFullContractById:(NSString *)contractId withSuccessHandler:(void(^)(id responseObject))success
                 andFailureHandler:(void(^)(NSError * error, NSString* message))failure {
    
    NSString *path = [NSString stringWithFormat:@"/contracts/%@", contractId];
    
    [self requestWithType:GET path:path andParams:nil withSuccessHandler:^(id  _Nonnull responseObject) {
        success(responseObject);
    } andFailureHandler:^(NSError * _Nonnull error, NSString *message) {
        failure(error, message);
    }];
}

@end
