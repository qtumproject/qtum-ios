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

@end
