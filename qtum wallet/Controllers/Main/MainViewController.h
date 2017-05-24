//
//  MainViewController.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletHistoryDelegateDataSource.h"
#import "Paginationable.h"

@protocol WalletCoordinatorDelegate;

@interface MainViewController : BaseViewController <ControllerDelegate,Paginationable>

@property (strong,nonatomic) WalletHistoryDelegateDataSource* delegateDataSource;
@property (weak,nonatomic) id <WalletCoordinatorDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *wigetBalanceLabel;

-(void)reloadTableView;
-(void)setBalance;
-(void)failedToGetData;
-(void)failedToGetBalance;
-(void)startLoading;
-(void)stopLoading;
-(void)reloadHistorySection;



@end
