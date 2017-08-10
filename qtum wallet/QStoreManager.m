//
//  QStoreManager.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreManager.h"
#import "QStoreCategory.h"
#import "QStoreRequestAdapter.h"
#import "QStoreShortContractElement.h"

NSString *const QStoreCategoryTrendingPath = @"/contracts/trending-now";
NSString *const QStoreCategoryLastAddedPath = @"/contracts/last-added";

NSInteger const QStoreSearchCount = 20;

@interface QStoreManager()

@property (nonatomic) QStoreRequestAdapter *requestAdapter;

@property NSMutableArray<QStoreCategory *> *categories;
@property NSMutableArray<QStoreCategory *> *categoriesInUpdate;

@property (nonatomic) NSString *searchString;
@property (nonatomic) QStoreManagerSearchType currnentSearchType;
@property (nonatomic) NSMutableArray<NSString *> *searchQueue;
@property (nonatomic) NSMutableArray<QStoreSearchContractElement *> *searchResult;

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
        _requestAdapter = [QStoreRequestAdapter new];
        _searchQueue = [NSMutableArray new];
        _searchResult = [NSMutableArray new];
        
        [self createStandartCategories];
    }
    
    return self;
}

#pragma mark - Private

- (void)createStandartCategories {
    QStoreCategory *trending = [[QStoreCategory alloc] initWithIdentifier:0 title:NSLocalizedString(@"Trending Now", nil) urlPath:QStoreCategoryTrendingPath];
    QStoreCategory *lastAdded = [[QStoreCategory alloc] initWithIdentifier:1 title:NSLocalizedString(@"Last Added", nil) urlPath:QStoreCategoryLastAddedPath];
    
    [self.categories addObject:trending];
    [self.categories addObject:lastAdded];
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

- (void)loadFullContractByShort:(QStoreShortContractElement *)element
             withSuccessHandler:(void (^)(QStoreFullContractElement *))success
              andFailureHandler:(void (^)(NSString *))failure {
    
    [self.requestAdapter getFullContractById:element.idString withSuccessHandler:^(QStoreFullContractElement *contract) {
        success(contract);
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(message);
    }];
}

#pragma mark - Abi

- (void)getContractABI:(QStoreFullContractElement *)element
    withSuccessHandler:(void (^)(QStoreFullContractElement *updatedElement))success
     andFailureHandler:(void (^)(NSString *message))failure{
    
    [self.requestAdapter getContractABI:element withSuccessHandler:^(QStoreFullContractElement *element) {
        success(element);
    } andFailureHandler:^(NSError *error, NSString *message) {
        failure(message);
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
            [self startSearchByTagWithOffset:0];
            break;
        case QStoreManagerSearchTypeName:
            
            break;
        default:
            break;
    }
}

- (void)startSearchByTagWithOffset:(NSInteger)offset {
    __weak typeof(self) weakSelf = self;
    [self.requestAdapter searchContractsByCount:QStoreSearchCount offset:offset type:QStoreRequestAdapterSearchTypeAll tags:@[self.searchString] withSuccessHandler:^(NSArray<QStoreSearchContractElement *> *elements, NSArray<NSString *> *tags) {
        
        NSString *tagString = [tags firstObject];
        if ([weakSelf.searchString isEqualToString:tagString]) {
            [weakSelf.searchResult addObjectsFromArray:elements];
            if (weakSelf.searchResult.count > QStoreSearchCount) {
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
            [self startSearchByTagWithOffset:self.searchResult.count];
            break;
        case QStoreManagerSearchTypeName:
            
            break;
        default:
            break;
    }
}

@end
