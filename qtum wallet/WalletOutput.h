//
//  WalletOutput.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 05.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WalletOutputDelegate.h"

@class WalletTableSource;

@protocol WalletOutput <NSObject>

@property (strong, nonatomic) WalletTableSource* tableSource;
@property (weak, nonatomic) id<WalletOutputDelegate> delegate;

- (void)setWallet:(id<Spendable>)wallet;
- (void)reloadTableView;
- (void)failedToGetData;
- (void)failedToGetBalance;
- (void)startLoading;
- (void)stopLoading;
- (void)reloadHeader:(id<Spendable>)wallet;

@end
