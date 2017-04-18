//
//  WalletModel.m
//  qtum wallet
//
//  Created by Никита Федоренко on 03.04.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "WalletModel.h"

@implementation WalletModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _type = Walletable;
    }
    return self;
}

@end
