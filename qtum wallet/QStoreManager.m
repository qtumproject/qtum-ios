//
//  QStoreManager.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreManager.h"
#import "QStoreCategory.h"
#import "QStoreDataProvider.h"
#import "QStoreContractElement.h"
#import "TransactionManager.h"
#import "ApplicationCoordinator.h"
#import "Wallet.h"
#import "SocketManager.h"
#import "FXKeychain.h"
#import "QStoreRequestManager.h"
#import "QStoreContractDownloadManager.h"

NSString *const QStoreCategoryTrendingPath = @"/contracts/trending-now";
NSString *const QStoreCategoryLastAddedPath = @"/contracts/last-added";

NSString *const kQStoreBuyRequestsManager = @"kQStoreBuyRequestsManager";

NSInteger const QStoreSearchCount = 20;

@interface QStoreManager()

@property (nonatomic) QStoreDataProvider *requestAdapter;

@property NSMutableArray<QStoreCategory *> *categories;
@property NSMutableArray<QStoreCategory *> *categoriesInUpdate;

@property (nonatomic) NSString *searchString;
@property (nonatomic) QStoreManagerSearchType currnentSearchType;
@property (nonatomic) NSMutableArray<NSString *> *searchQueue;
@property (nonatomic) NSMutableArray<QStoreContractElement *> *searchResult;
@property (strong, nonatomic) QStoreRequestManager* requestsManger;
@property (strong, nonatomic) QStoreContractDownloadManager* dowloadManager;

@property (assign, nonatomic) BOOL observingForSpendableFailed;
@property (assign, nonatomic) BOOL observingForSpendableStopped;

@end

@implementation QStoreManager

+ (instancetype)sharedInstance {
    static QStoreManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[super alloc] initUniqueInstance];
    });
    return manager;
}

- (instancetype)initUniqueInstance {
    self = [super init];
    
    if (self != nil) {
        _categories = [NSMutableArray new];
        _categoriesInUpdate = [NSMutableArray new];
        _requestAdapter = [QStoreDataProvider new];
        _searchQueue = [NSMutableArray new];
        _searchResult = [NSMutableArray new];
        _dowloadManager = [[QStoreContractDownloadManager alloc] initWithDataProvider:_requestAdapter];
        
        [self load];
        [self createStandartCategories];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didContinieObservingForSpendable)
                                                     name:kSocketDidConnect object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didForceStopObservingForSpendable)
                                                     name:kSocketDidDisconnect object:nil];
    }
    
    return self;
}

- (BOOL)save {
    
    BOOL isSaved = [[FXKeychain defaultKeychain] setObject:self.requestsManger forKey:kQStoreBuyRequestsManager];

    return isSaved;
}

- (void)load {
    
    QStoreRequestManager *requestManager = [[FXKeychain defaultKeychain] objectForKey:kQStoreBuyRequestsManager];
    self.requestsManger = requestManager ?: [QStoreRequestManager new];
}


#pragma mark - Observing

-(void)didContinieObservingForSpendable {
    
    if (self.observingForSpendableFailed && !self.observingForSpendableStopped) {
        [self startObservingForAllRequests];
    }
    self.observingForSpendableFailed = NO;
}

-(void)didForceStopObservingForSpendable {
    
    self.observingForSpendableFailed = YES;
}

#pragma mark - Private

- (void)createStandartCategories {
    QStoreCategory *trending = [[QStoreCategory alloc] initWithIdentifier:0 title:NSLocalizedString(@"Trending Now", nil) urlPath:QStoreCategoryTrendingPath];
    QStoreCategory *lastAdded = [[QStoreCategory alloc] initWithIdentifier:1 title:NSLocalizedString(@"Last Added", nil) urlPath:QStoreCategoryLastAddedPath];
    
    [self.categories addObject:trending];
    [self.categories addObject:lastAdded];
}

- (void)subscribeToRequestUpdate:(NSString*) requestString {
    
    [[ApplicationCoordinator sharedInstance].requestManager startObservingContractPurchase:requestString withHandler:nil];
}


#pragma mark - Public

- (void)loadContractsForCategoriesWithSuccessHandler:(void (^)(NSArray<QStoreCategory *> *))success
                                   andFailureHandler:(void (^)(NSString *))failure {
    
    for (QStoreCategory *category in self.categories) {
        [self.categoriesInUpdate addObject:category];
        
        __weak typeof(self) weakSelf = self;
        [self.requestAdapter getContractsForCategory:category withSuccessHandler:^(QStoreCategory *updatedCategory) {
            [weakSelf.categoriesInUpdate removeObject:category];
            if (weakSelf.categoriesInUpdate.count == 0) {
                success(weakSelf.categories);
            }
        } andFailureHandler:^(NSError *error, NSString *message) {
            failure(message);
        }];
    }
}

- (void)loadFullContract:(QStoreContractElement *)element
      withSuccessHandler:(void (^)())success
       andFailureHandler:(void (^)(NSString *))failure {
    
    __weak typeof(self) weakSelf = self;
    [self.requestAdapter getFullContractById:element.idString withSuccessHandler:^(NSDictionary *fullDictionary) {
        [element updateWithFullDictionary:fullDictionary];
        QStoreBuyRequest *request = [weakSelf.requestsManger requestByElement:element];
        if (request) {
            element.purchaseState = request.state == QStoreBuyRequestStateInPayment ? QStoreElementPurchaseStateInPurchase : QStoreElementPurchaseStatePurchased;
        }
        success();
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(message);
    }];
}

- (void)getSourceCode:(NSString *)contractId
            requestId:(NSString *)requestId
          accessToken:(NSString *)accessToken
   withSuccessHandler:(void(^)(NSString *sourceCode))success
    andFailureHandler:(void(^)(NSError * error, NSString* message))failure {
    
    [self.requestAdapter getSourceCode:contractId requestId:requestId accessToken:accessToken withSuccessHandler:success andFailureHandler:failure];
}

#pragma mark - Abi

- (void)getContractABIWithElement:(QStoreContractElement *)element
    withSuccessHandler:(void (^)())success
     andFailureHandler:(void (^)(NSString *message))failure{
    
    [self.requestAdapter getContractABIWithElement:element withSuccessHandler:^(NSString *abiString) {
        element.abiString = abiString;
        success();
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(message);
    }];
}

#pragma mark - Buy Requests


- (void)purchaseContract:(QStoreContractElement *)element
      withSuccessHandler:(void (^)())success
       andFailureHandler:(void (^)(NSString *message))failure {
    
    __weak typeof(self) weakSelf = self;
    [self.requestAdapter buyContract:element.idString withSuccessHandler:^(NSDictionary *buyRequestDictionary) {
        QStoreBuyRequest *request = [QStoreBuyRequest createFromDictionary:buyRequestDictionary andContractId:element.idString withProductName:element.name withProductType:element.type];
        [weakSelf createBuyTrancaction:request withSuccessHandler:^{
            
            [weakSelf.requestsManger addBuyRequest:request completion:^{
                [weakSelf save];
                dispatch_async(dispatch_get_main_queue(), ^{
                    success();
                });
            }];
            [weakSelf subscribeToRequestUpdate:request.requestId];
            element.purchaseState = QStoreElementPurchaseStateInPurchase;
        } andFailureHandler:^(NSString *message) {
            failure(message);
        }];
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(message);
    }];
}

- (void)createBuyTrancaction:(QStoreBuyRequest *)buyRequest
          withSuccessHandler:(void (^)())success
           andFailureHandler:(void (^)(NSString *message))failure {
    
    
    NSArray *array = @[@{@"amount" : [buyRequest getAmountNumber], @"address" : buyRequest.addressString}];
    
    [[TransactionManager sharedInstance] sendTransactionWalletKeys:[[ApplicationCoordinator sharedInstance].walletManager.wallet
                                                                    allKeys]
                                                toAddressAndAmount:array
                                                               fee:nil
                                                        andHandler:^(TransactionManagerErrorType errorType, id response) {
        if (errorType == TransactionManagerErrorTypeNone) {
            success();
        } else {
            // TODO add more error messages
            failure(NSLocalizedString(@"Cannot create transaction", nil));
        }
    }];
}

#pragma mark - Search

- (void)searchByString:(NSString *)string searchType:(QStoreManagerSearchType)type {
    
    if ([string isEqualToString:@""]) {
        [self clearSearch];
        if ([self.delegate respondsToSelector:@selector(didFindElements:)]) {
            [self.delegate didFindElements:[NSArray new]];
        }
        return;
    }
    
    if (self.currnentSearchType != type) {
        [self clearSearch];
        if ([self.delegate respondsToSelector:@selector(didFindElements:)]) {
            [self.delegate didFindElements:[NSArray new]];
        }
    }
    
    if (self.searchString && [self.searchString isEqualToString:string]) {
        return;
    }
    
    if (self.currnentSearchType == QStoreManagerSearchTypeNone) {
        self.searchString = string;
        self.currnentSearchType = type;
        [self.searchResult removeAllObjects];
        [self startSearch];
        return;
    }
    
    [self.searchQueue removeAllObjects];
    [self.searchQueue addObject:string];
}

- (void)clearSearch {
    self.searchString = nil;
    [self.searchQueue removeAllObjects];
    [self.searchResult removeAllObjects];
    self.currnentSearchType = QStoreManagerSearchTypeNone;
}

- (void)startSearch {
    switch (self.currnentSearchType) {
        case QStoreManagerSearchTypeTag:
            [self startSearchByTagWithOffset:0 findMore:NO];
            break;
        case QStoreManagerSearchTypeName:
            
            break;
        default:
            break;
    }
}

- (void)startSearchByTagWithOffset:(NSInteger)offset findMore:(BOOL)findMore {
    __weak typeof(self) weakSelf = self;
    [self.requestAdapter searchContractsByCount:QStoreSearchCount offset:offset type:QStoreDataProviderSearchTypeAll tags:@[self.searchString] withSuccessHandler:^(NSArray<QStoreContractElement *> *elements, NSArray<NSString *> *tags) {
        
        NSString *tagString = [tags firstObject];
        if ([weakSelf.searchString isEqualToString:tagString]) {
            [weakSelf.searchResult addObjectsFromArray:elements];
            if (findMore) {
                if ([weakSelf.delegate respondsToSelector:@selector(didFindMoreElements:)]) {
                    [weakSelf.delegate didFindMoreElements:[NSArray arrayWithArray:weakSelf.searchResult]];
                }
            } else {
                if ([weakSelf.delegate respondsToSelector:@selector(didFindElements:)]) {
                    [weakSelf.delegate didFindElements:[NSArray arrayWithArray:weakSelf.searchResult]];
                }
            }
        }
        
        if (weakSelf.searchQueue.count > 0) {
            [weakSelf.searchResult removeAllObjects];
            weakSelf.searchString = [weakSelf.searchQueue firstObject];
            [weakSelf.searchQueue removeObjectAtIndex:0];
            [weakSelf startSearch];
        } else {
            weakSelf.currnentSearchType = QStoreManagerSearchTypeNone;
        }
    } andFailureHandler:^(NSError *error, NSString *message) {
        
    }];
}

- (void)searchMoreItemsByString:(NSString *)string searchType:(QStoreManagerSearchType)type {
    if (![string isEqualToString:self.searchString] || self.currnentSearchType != QStoreManagerSearchTypeNone) {
        return;
    }
    
    self.currnentSearchType = type;
    self.searchString = string;
    [self startSearchMore];
}

- (void)startSearchMore {
    switch (self.currnentSearchType) {
        case QStoreManagerSearchTypeTag:
            [self startSearchByTagWithOffset:self.searchResult.count findMore:YES];
            break;
        case QStoreManagerSearchTypeName:
            
            break;
        default:
            break;
    }
}

- (QStoreBuyRequest*)requestWithContractId:(NSString*) contractId {
    
    return [self.requestsManger requestWithContractId:contractId];
}

- (void)checkRequestPaid:(NSString *)contractId
               requestId:(NSString *)requestId
      withSuccessHandler:(void(^)(NSDictionary *paidObject))success
       andFailureHandler:(void(^)(NSError * error, NSString* message))failure {
    [self.requestAdapter checkRequestPaid:contractId requestId:requestId withSuccessHandler:^(NSDictionary *paidObject) {
        success(paidObject);
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(error, message);
    }];
}

#pragma mark - Observing

- (void)startObservingForAllRequests {

    self.observingForSpendableStopped = NO;
    
    NSArray <QStoreBuyRequest*> *requests = self.requestsManger.buyRequests;
    
    for (QStoreBuyRequest* request in requests) {
        [self subscribeToRequestUpdate:request.requestId];
        [self checkRequestIsPaid:request];
    }
    
    [self downloadAllRequests];
}

-(void)downloadAllRequests {
    
    NSArray <QStoreBuyRequest*> *requests = self.requestsManger.confirmedBuyRequests;

    __weak __typeof(self)weakSelf = self;
    for (QStoreBuyRequest* request in requests) {
        [weakSelf downloadRequest:request];
    }
}

-(void)downloadRequest:(QStoreBuyRequest*) request {
    
    __weak __typeof(self)weakSelf = self;
    [self.dowloadManager downloadContractWithRequest:request completion:^(BOOL success, QStoreBuyRequest* request) {
        
        if (success) {
            
            [weakSelf.requestsManger finishBuyRequest:request completion:^{
                [weakSelf save];
            }];
        }
    }];
}

- (void)stopObservingForAllRequests {
    
    self.observingForSpendableStopped = YES;
}

-(void)updateContractRequestsWithDict:(NSDictionary*) dict {
    
    __weak __typeof(self)weakSelf = self;
    QStoreBuyRequest* request = [self.requestsManger requestWithContractId:dict[QStoreBuyRequestContractIdKey]];
    
    if (request) {
        [request upateFromDictionary:dict];
    }
    
    if (request.state == QStoreBuyRequestStateIsPaid) {
        [weakSelf.requestsManger confirmBuyRequest:request completion:^{
            [weakSelf save];
            [weakSelf downloadRequest:request];
        }];
    }
}

#pragma mark -

- (void)checkAllRequestsPaid {
    
    NSArray <QStoreBuyRequest*> *requests = self.requestsManger.buyRequests;
    
    __weak typeof(self)weakSelf = self;
    
    for (QStoreBuyRequest* request in requests) {
        
        [weakSelf checkRequestIsPaid:request];
    }
}

- (void)checkRequestIsPaid:(QStoreBuyRequest*) request {
    
    __weak typeof(self)weakSelf = self;
    [self checkRequestPaid:request.contractId requestId:request.requestId withSuccessHandler:^(NSDictionary *paidObject) {
        
        [request upateFromDictionary:paidObject];
        
        if (request.state == QStoreBuyRequestStateIsPaid) {
            [weakSelf.requestsManger confirmBuyRequest:request completion:^{
                [weakSelf save];
                [weakSelf downloadRequest:request];
            }];
        }
    } andFailureHandler:^(NSError *error, NSString *message) {
        
    }];
}

#pragma mark - Clearable

-(void)clear {
    
    self.requestsManger = [QStoreRequestManager new];
    [self save];
}

@end
