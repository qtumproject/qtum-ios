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
}

#pragma mark - Actions

- (IBAction)actionShare:(id)sender {
    [self.delegate didShareTokenButtonPressed];
}

- (IBAction)actionBack:(id)sender {
    [self.delegate didBackPressed];
}

#pragma mark - TokenDetailDisplayDataManagerDelegate

- (void)didPressedInfoActionWithToken:(Contract*) aToken {
    [self.delegate showAddressInfoWithSpendable:aToken];
}

- (IBAction)didPressTokenAddressControl:(id)sender {
    [self.delegate didShowTokenAddressControl];
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

- (void)updateHeader:(Contract *)token{
    self.availableBalanceLabel.text = [NSString stringWithFormat:@"%f", self.token.balance];
}

@end
