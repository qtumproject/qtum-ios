//
//  WalletTypeCollectionDataSourceDelegate.h
//  qtum wallet
//
//  Created by Никита Федоренко on 03.04.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletCoordinator.h"
@class WalletModel;

@protocol WalletCollectionCellDelegate <NSObject>

@required
-(void)showAddressInfo;

@end

@interface WalletTypeCollectionDataSourceDelegate : NSObject <UICollectionViewDelegate, UICollectionViewDataSource, WalletCollectionCellDelegate>
@property (strong, nonatomic) NSArray<WalletModel*>* wallets;
@property (weak,nonatomic) id <WalletCoordinatorDelegate> delegate;

@end
