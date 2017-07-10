//
//  MainViewController.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.11.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletTableSource.h"
#import "WalletOutput.h"

@class ViewWithAnimatedLine;

@interface WalletViewController : BaseViewController <ControllerDelegate, WalletOutput>

@property (strong, nonatomic) WalletTableSource* tableSource;
@property (weak, nonatomic) id <WalletOutputDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *availabelLabel;
@property (weak, nonatomic) IBOutlet UILabel *uncorfirmedLabel;
@property (weak, nonatomic) IBOutlet UILabel *unconfirmedTextLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *availableTextTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *availableValueTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *viewForHeaderInSecondSection;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

- (void)configTableView;
- (void)configRefreshControl;
- (void)refreshFromRefreshControl;

@end
