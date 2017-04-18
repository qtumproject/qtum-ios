//
//  Walletable.h
//  qtum wallet
//
//  Created by Никита Федоренко on 18.04.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, WalletType) {
    Wallet,
    Token
};

@protocol Walletable <NSObject>

@required
@property (copy, nonatomic) NSString* name;
@property (copy, nonatomic) NSString* balance;
@property (assign, nonatomic) WalletType type;

@end
