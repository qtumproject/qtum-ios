//
//  WalletHistoryDelegateDataSource.h
//  qtum wallet
//
//  Created by Никита Федоренко on 06.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletCoordinator.h"
@class HistoryElement;
@class WalletModel;
@class WalletTypeCollectionDataSourceDelegate;


@interface WalletHistoryDelegateDataSource : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) WalletModel* wallet;
@property (strong,nonatomic) WalletTypeCollectionDataSourceDelegate* collectionDelegateDataSource;
@property (weak,nonatomic) id <WalletCoordinatorDelegate> delegate;

@end
