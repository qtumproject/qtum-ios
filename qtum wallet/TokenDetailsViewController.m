//
//  TokenDetailsViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 19.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "TokenDetailsViewController.h"
#import "WalletCoordinator.h"
#import "TokenDetailsTableSource.h"
#import "ViewWithAnimatedLine.h"
#import "ShareTokenPopUpViewController.h"

CGFloat const HeightForHeaderView = 50.0f;

@interface TokenDetailsViewController () <TokenDetailsTableSourceDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *availableBalanceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConsctaintForHeaderView;
@property (weak, nonatomic) IBOutlet ViewWithAnimatedLine *headerVIew;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingForLineConstraint;
@property (weak, nonatomic) IBOutlet UIView *activityView;

@property (nonatomic, weak) TokenDetailsTableSource *source;

@end

@implementation TokenDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.source.delegate = self;
    self.tableView.dataSource = self.source;
    self.tableView.delegate = self.source;
    
    [self.headerVIew setRightConstraint:self.trailingForLineConstraint];
    [self updateHeader:self.token];
    
    self.titleLabel.text = (self.token.name && self.token.name.length > 0) ? self.token.name : NSLocalizedString(@"Token Details", nil);
}

- (void)setTableSource:(TokenDetailsTableSource *)source{
    self.source = source;
}

#pragma mark - Actions

- (IBAction)actionShare:(id)sender {
    [self.delegate didShareTokenButtonPressed];
}

- (IBAction)actionBack:(id)sender {
    [self.delegate didBackPressed];
}

#pragma mark - TokenDetailsTableSourceDelegate

- (void)didPressedInfoActionWithToken:(Contract*)token {
    [self.delegate showAddressInfoWithSpendable:token];
}

- (void)needShowHeader{
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

- (void)updateHeader:(Contract *)token{
    self.availableBalanceLabel.text = [NSString stringWithFormat:@"%f", self.token.balance];
}

@end
