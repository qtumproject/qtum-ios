//
//  TokenDetailsViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 19.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "TokenDetailsViewController.h"
#import "WalletCoordinator.h"
#import "TokenDetailsTableSource.h"
#import "ViewWithAnimatedLine.h"
#import "ShareTokenPopUpViewController.h"
#import "TokenDetailDisplayDataManagerDelegate.h"

CGFloat const HeightForHeaderView = 50.0f;

@interface TokenDetailsViewController () <TokenDetailDisplayDataManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *availableBalanceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConsctaintForHeaderView;
@property (weak, nonatomic) IBOutlet ViewWithAnimatedLine *headerVIew;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingForLineConstraint;
@property (weak, nonatomic) IBOutlet UIView *activityView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation TokenDetailsViewController

@synthesize token, delegate, source;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.source.delegate = self;
    self.tableView.dataSource = self.source;
    self.tableView.delegate = self.source;
    
    [self.headerVIew setRightConstraint:self.trailingForLineConstraint];
    [self updateHeader:self.token];
    
    self.titleLabel.text = (self.token.name && self.token.name.length > 0) ? self.token.name : NSLocalizedString(@"Token Details", nil);
    
    [self configRefreshControl];
}

-(void)configRefreshControl {
    
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.tintColor = customBlackColor();
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshFromRefreshControl) forControlEvents:UIControlEventValueChanged];
    
    CGRect frame = self.view.bounds;
    frame.origin.y = - frame.size.height;
    UIView *refreshBackgroundView = [[UIView alloc]initWithFrame:frame];
    refreshBackgroundView.backgroundColor = customBlueColor();
    [self.tableView insertSubview:refreshBackgroundView atIndex:0];
}

#pragma mark - Actions

- (IBAction)actionShare:(id)sender {
    [self.delegate didShareTokenButtonPressed];
}

- (IBAction)actionBack:(id)sender {
    [self.delegate didBackPressed];
}

-(void)refreshFromRefreshControl {
    
    [self.delegate didPullToUpdateToken:self.token];
}

#pragma mark - Output

-(void)updateControls {

    [self refreshTable];
}

#pragma mark - TokenDetailDisplayDataManagerDelegate

- (void)didPressedInfoActionWithToken:(Contract*) aToken {
    [self.delegate showAddressInfoWithSpendable:aToken];
}

- (void)didPressTokenAddressControlWithToken:(Contract*) aToken {
    [self.delegate didShowTokenAddressControlWith:aToken];
}

- (void)needShowHeader {
    if (self.heightConsctaintForHeaderView.constant == HeightForHeaderView) {
        return;
    }
    
    self.heightConsctaintForHeaderView.constant = HeightForHeaderView;
    [self.headerVIew showAnimation];
}

- (void)needHideHeader{
    if (self.heightConsctaintForHeaderView.constant == 0.0f) {
        return;
    }
    
    self.heightConsctaintForHeaderView.constant = 0;
}

- (void)needShowHeaderForSecondSeciton {
    self.activityView.hidden = NO;
}
- (void)needHideHeaderForSecondSeciton {
    self.activityView.hidden = YES;
}

#pragma mark - Methods

- (void)updateHeader:(Contract *)token {
    
    self.availableBalanceLabel.text = [NSString stringWithFormat:@"%@ %@",token.balanceString ?: @"", token.symbol ?: @""];
}

-(void)refreshTable {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    });
}

@end
