//
//  RequestManager.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 20.05.17.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "RequestManager.h"
#import <CommonCrypto/CommonHMAC.h>
#import "ServerAdapter.h"
#import "SocketManager.h"
#import "Wallet.h"
#import "NetworkingService.h"

@interface RequestManager()

@property (strong,nonatomic) id <RequestManagerAdapter> adapter;
@property (strong,nonatomic) SocketManager *socketManager;
@property (strong, nonatomic) NetworkingService* networkService;

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
        
        _adapter = [ServerAdapter new];
        _networkService = [[NetworkingService alloc] initWithBaseUrl:[self baseURL]];
    }

    return self;
}


#pragma mark - Setup and Privat Methods

-(SocketManager *)socketManager {
    
    if (!_socketManager) {
        _socketManager = [SocketManager new];
        _socketManager.delegate = self;
    }
    return _socketManager;
}

-(NSString*)baseURL {
    
    return [AppSettings sharedInstance].baseURL;
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
    
    [self.networkService requestWithType:POST path:@"send-raw-transaction" andParams:param withSuccessHandler:^(id  _Nonnull responseObject) {
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
    
    [self.networkService requestWithType:GET path:pathString andParams:param withSuccessHandler:^(id  _Nonnull responseObject) {
        
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
    
    [self.networkService requestWithType:GET path:@"news/en" andParams:nil withSuccessHandler:^(id  _Nonnull responseObject) {
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

    [self.networkService requestWithType:GET path:pathString andParams:adressesForParam withSuccessHandler:^(id  _Nonnull responseObject) {
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

    [self.networkService requestWithType:GET path:pathString andParams:nil withSuccessHandler:^(id  _Nonnull responseObject) {
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
    [self.networkService requestWithType:GET path:@"blockchain/info" andParams:nil withSuccessHandler:^(id  _Nonnull responseObject) {
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
    
    [self.networkService requestWithType:POST path:@"contracts/generate-token-bytecode" andParams:param withSuccessHandler:^(id  _Nonnull responseObject) {
        success(responseObject);
    } andFailureHandler:^(NSError * _Nonnull error, NSString *message) {
        failure(error, message);
    }];
}

- (void)callFunctionToContractAddress:(NSString*) address
                           withHashes:(NSArray*) hashes
                          withHandler:(void(^)(id responseObject))completesion {

    NSString* pathString = [NSString stringWithFormat:@"/contracts/%@/call",address];


    [self.networkService requestWithType:POST path:pathString andParams:@{@"hashes" : hashes} withSuccessHandler:^(id  _Nonnull responseObject) {
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
    
    [self.networkService requestWithType:GET path:path andParams:nil withSuccessHandler:^(id  _Nonnull responseObject) {
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

- (void)startObservingForToken:(Contract*) token withHandler:(void(^)(void))completesion {
    
    [self.socketManager startObservingToken:token withHandler:completesion];
}

- (void)stopObservingForToken:(Contract*) token {
    
    [self.socketManager stopObservingToken:token withHandler:nil];
}

- (void)startObservingContractPurchase:(NSString*) requestId withHandler:(void(^)(void)) handler {
    
    [self.socketManager startObservingContractPurchase:requestId withHandler:handler];
}

- (void)stopObservingContractPurchase:(NSString*) requestId withHandler:(void(^)(void)) handler {
    
    [self.socketManager stopObservingContractPurchase:requestId withHandler:handler];
}

#pragma mark - QStore

- (void)getContractsByCategoryPath:(NSString *)path withSuccessHandler:(void(^)(id responseObject))success
        andFailureHandler:(void(^)(NSError * error, NSString* message))failure {
    
    [self.networkService requestWithType:GET path:path andParams:nil withSuccessHandler:^(id  _Nonnull responseObject) {
        success(responseObject);
    } andFailureHandler:^(NSError * _Nonnull error, NSString *message) {
        failure(error, message);
    }];
}

- (void)getFullContractById:(NSString *)contractId withSuccessHandler:(void(^)(id responseObject))success
                 andFailureHandler:(void(^)(NSError * error, NSString* message))failure {
    
    NSString *path = [NSString stringWithFormat:@"/contracts/%@", contractId];
    
    [self.networkService requestWithType:GET path:path andParams:nil withSuccessHandler:^(id  _Nonnull responseObject) {
        success(responseObject);
    } andFailureHandler:^(NSError * _Nonnull error, NSString *message) {
        failure(error, message);
    }];
}

- (void)searchContractsByCount:(NSInteger)count
                        offset:(NSInteger)offset
                          type:(NSString *)type
                          tags:(NSArray *)tags
                          name:(NSString *)name
            withSuccessHandler:(void(^)(id responseObject))success
             andFailureHandler:(void(^)(NSError * error, NSString* message))failure {
    
    NSString *path = [NSString stringWithFormat:@"/contracts/%@/%@", @(count), @(offset)];
    NSMutableDictionary *dictionary= [NSMutableDictionary new];
    if (type) [dictionary setObject:type forKey:@"type"];
    if (tags) [dictionary setObject:tags forKey:@"tags"];
    if (name) [dictionary setObject:name forKey:@"name"];
    
    [self.networkService requestWithType:GET path:path andParams:dictionary withSuccessHandler:^(id  _Nonnull responseObject) {
        success(responseObject);
    } andFailureHandler:^(NSError * _Nonnull error, NSString *message) {
        failure(error, message);
    }];
}

- (void)getContractABI:(NSString *)contractId
    withSuccessHandler:(void(^)(id responseObject))success
     andFailureHandler:(void(^)(NSError * error, NSString* message))failure{
    
    NSString *path = [NSString stringWithFormat:@"/contracts/%@/abi", contractId];
    
    [self.networkService requestWithType:GET path:path andParams:nil withSuccessHandler:^(id  _Nonnull responseObject) {
        success(responseObject);
    } andFailureHandler:^(NSError * _Nonnull error, NSString *message) {
        failure(error, message);
    }];
}

- (void)buyContract:(NSString *)contractId withSuccessHandler:(void(^)(id responseObject))success
  andFailureHandler:(void(^)(NSError * error, NSString* message))failure {
    
    NSString *path = [NSString stringWithFormat:@"/contracts/%@/buy-request", contractId];
    
    [self.networkService requestWithType:POST path:path andParams:nil withSuccessHandler:^(id  _Nonnull responseObject) {
        success(responseObject);
    } andFailureHandler:^(NSError * _Nonnull error, NSString *message) {
        failure(error, message);
    }];
}

- (void)checkRequestPaid:(NSString *)contractId
               requestId:(NSString *)requestId
      withSuccessHandler:(void(^)(id responseObject))success
       andFailureHandler:(void(^)(NSError * error, NSString* message))failure {
    
    NSString *path = [NSString stringWithFormat:@"/contracts/%@/is-paid/by-request-id", contractId];
    NSDictionary *dictionary = @{@"request_id" : requestId};
    
    [self.networkService requestWithType:GET path:path andParams:dictionary withSuccessHandler:^(id  _Nonnull responseObject) {
        success(responseObject);
    } andFailureHandler:^(NSError * _Nonnull error, NSString *message) {
        failure(error, message);
    }];
}

- (void)getSourceCode:(NSString *)contractId
            requestId:(NSString *)requestId
            accessToken:(NSString *)accessToken
   withSuccessHandler:(void(^)(id responseObject))success
    andFailureHandler:(void(^)(NSError * error, NSString* message))failure {
    
    NSString *path = [NSString stringWithFormat:@"/contracts/%@/source-code", contractId];
    NSDictionary *dictionary = @{@"request_id" : requestId,
                                 @"access_token" : accessToken};
    
    [self.networkService requestWithType:POST path:path andParams:dictionary withSuccessHandler:^(id  _Nonnull responseObject) {
        success(responseObject);
    } andFailureHandler:^(NSError * _Nonnull error, NSString *message) {
        failure(error, message);
    }];
}

- (void)getByteCode:(NSString *)contractId
     buyerAddresses:(NSString *)buyerAddresses
              nonce:(NSNumber *)nonce
              signs:(NSArray *)signs
 withSuccessHandler:(void(^)(id responseObject))success
  andFailureHandler:(void(^)(NSError * error, NSString* message))failure {
    
    NSString *path = [NSString stringWithFormat:@"/contracts/%@/bytecode", contractId];
    NSDictionary *dictionary = @{@"buyer_addresses" : buyerAddresses,
                                 @"nonce" : nonce,
                                 @"signs" : signs};
    
    [self.networkService requestWithType:POST path:path andParams:dictionary withSuccessHandler:^(id  _Nonnull responseObject) {
        success(responseObject);
    } andFailureHandler:^(NSError * _Nonnull error, NSString *message) {
        failure(error, message);
    }];
}

- (void)getByteCode:(NSString *)contractId
          requestId:(NSString *)requestId
        accessToken:(NSString *)accessToken
 withSuccessHandler:(void(^)(id responseObject))success
  andFailureHandler:(void(^)(NSError * error, NSString* message))failure {
    
    NSString *path = [NSString stringWithFormat:@"/contracts/%@/bytecode", contractId];
    NSDictionary *dictionary = @{@"request_id" : requestId,
                                 @"access_token" : accessToken};
    
    [self.networkService requestWithType:POST path:path andParams:dictionary withSuccessHandler:^(id  _Nonnull responseObject) {
        success(responseObject);
    } andFailureHandler:^(NSError * _Nonnull error, NSString *message) {
        failure(error, message);
    }];
}


- (void)getFeePerKbWithSuccessHandler:(void(^)(QTUMBigNumber* feePerKb))success
                    andFailureHandler:(void(^)(NSError * error, NSString* message))failure {
    
    NSString *path = @"/estimate-fee-per-kb?nBlocks=2";
    
    __weak __typeof(self)weakSelf = self;
    
    [self.networkService requestWithType:GET path:path andParams:nil withSuccessHandler:^(id  _Nonnull responseObject) {

        success([weakSelf.adapter adaptiveDataForFeePerKb:responseObject]);
    } andFailureHandler:^(NSError * _Nonnull error, NSString *message) {
        
        failure(error, message);
    }];
}

- (void)getCategories:(void(^)(id responseObject))success
    andFailureHandler:(void(^)(NSError * error, NSString* message))failure {
    
    NSString *path = @"contracts/types";
    
    [self.networkService requestWithType:GET path:path andParams:nil withSuccessHandler:^(id  _Nonnull responseObject) {
        success(responseObject);
    } andFailureHandler:^(NSError * _Nonnull error, NSString *message) {
        failure(error, message);
    }];
}

- (void)getDGPinfo:(void(^)(id responseObject))success andFailureHandler:(void(^)(NSError * error, NSString* message))failure {
    NSString *path = @"blockchain/dgpinfo";
    
    [self.networkService requestWithType:GET path:path andParams:nil withSuccessHandler:^(id  _Nonnull responseObject) {
        success(responseObject);
    } andFailureHandler:^(NSError * _Nonnull error, NSString *message) {
        failure(error, message);
    }];
}

@end
