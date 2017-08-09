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

@interface QStoreManager()

@property (nonatomic) QStoreRequestAdapter *requestAdapter;

@property NSMutableArray<QStoreCategory *> *categories;
@property NSMutableArray<QStoreCategory *> *categoriesInUpdate;

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

@end
