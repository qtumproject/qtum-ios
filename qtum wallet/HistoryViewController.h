//
//  HistoryViewController.h
//  qtum wallet
//
//  Created by Никита Федоренко on 27.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WalletCoordinatorDelegate;
@class WalletHistoryDelegateDataSource;

@interface HistoryViewController : UIViewController

@property (weak,nonatomic) id <WalletCoordinatorDelegate> delegate;
@property (strong,nonatomic) WalletHistoryDelegateDataSource* delegateDataSource;

-(void)reloadTableView;
-(void)failedToGetData;

@end
