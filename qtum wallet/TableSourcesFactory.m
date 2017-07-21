//
//  TableSourcesFactory.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 05.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "TableSourcesFactory.h"
#import "NSUserDefaults+Settings.h"
#import "WalletTableSourceDark.h"
#import "WalletTableSourceLight.h"
#import "ChooseTokenPaymentDelegateDataSourceDark.h"
#import "ChooseTokenPaymentDelegateDataSourceLight.h"
#import "LibraryTableSource.h"
#import "FavouriteTemplatesCollectionSource.h"
#import "NewsTableSourceDark.h"
#import "NewsTableSourceLight.h"

@implementation TableSourcesFactory

+ (instancetype)sharedInstance
{
    static TableSourcesFactory *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] initUniqueInstance];
    });
    return instance;
}

- (instancetype)initUniqueInstance
{
    self = [super init];
    if (self != nil) { }
    return self;
}

#pragma mark - Methods

- (WalletTableSource *)createWalletSource {
    
    if ([NSUserDefaults isDarkSchemeSetting]) {
        return [WalletTableSourceDark new];
    }else{
        return [WalletTableSourceLight new];
    }
}

- (NSObject <ChooseTokenPaymentDelegateDataSourceProtocol> *)createSendTokenPaymentSource {
    
    if ([NSUserDefaults isDarkSchemeSetting]) {
        return [ChooseTokenPaymentDelegateDataSourceDark new];
    }else{
        return [ChooseTokenPaymentDelegateDataSourceLight new];
    }
}

- (NSObject<LibraryTableSourceOutput> *)createLibrarySource {
    
    if ([NSUserDefaults isDarkSchemeSetting]) {
        return [LibraryTableSource new];
    }else{
        return [LibraryTableSource new];
    }
}

- (NSObject<FavouriteTemplatesCollectionSourceOutput> *)createFavouriteTemplatesSource {
    
    if ([NSUserDefaults isDarkSchemeSetting]) {
        return [FavouriteTemplatesCollectionSource new];
    }else{
        return [FavouriteTemplatesCollectionSource new];
    }
}

- (NSObject<NewsTableSourceOutput> *)createNewsSource {
    
    if ([NSUserDefaults isDarkSchemeSetting]) {
        return [NewsTableSourceDark new];
    }else{
        return [NewsTableSourceLight new];
    }
}

@end
