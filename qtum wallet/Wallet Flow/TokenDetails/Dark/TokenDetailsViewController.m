//
//  TokenDetailsViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 19.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "TokenDetailsViewController.h"
#import "ViewWithAnimatedLine.h"
#import "NoContractView.h"
#import "Masonry.h"

CGFloat const HeightForHeaderView = 50.0f;

@interface TokenDetailsViewController () <TokenDetailDisplayDataManagerDelegate, NoContractViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *noTransactionTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *availableBalanceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConsctaintForHeaderView;
@property (weak, nonatomic) IBOutlet ViewWithAnimatedLine *headerVIew;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingForLineConstraint;
@property (weak, nonatomic) IBOutlet UIView *activityView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIView *noTransactionView;
@property (weak, nonatomic) IBOutlet UIView *navigationBarView;
@property (weak, nonatomic) IBOutlet UIButton *navigationShareButton;

@end

static NSInteger noContractViewTopOffset = 0;
static NSInteger noContractViewBottomOffset = 0;
static NSInteger noContractViewLeading = 0;
static NSInteger noContractViewTrailing = 0;

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
    [self configLocalization];
    [self.delegate didPullToUpdateToken:self.token];
}

- (void)configRefreshControl {

	self.refreshControl = [[UIRefreshControl alloc] init];
	self.refreshControl.tintColor = customBlackColor ();
	[self.tableView addSubview:self.refreshControl];
	[self.refreshControl addTarget:self action:@selector (refreshFromRefreshControl) forControlEvents:UIControlEventValueChanged];

	CGRect frame = self.view.bounds;
	frame.origin.y = -frame.size.height;
	UIView *refreshBackgroundView = [[UIView alloc] initWithFrame:frame];
	refreshBackgroundView.backgroundColor = customBlueColor ();
	[self.tableView insertSubview:refreshBackgroundView atIndex:0];
}

-(void)configLocalization {
    
    self.noTransactionTextLabel.text = NSLocalizedString(@"No transactions available yet", @"");
}

#pragma mark - Private Methods

- (NoContractView *)getNoContractView {
    
    NoContractView *noContractView = [[[NSBundle mainBundle] loadNibNamed:@"NoContractView" owner:self options:nil] objectAtIndex:0];
    return noContractView;
}


#pragma mark - NoContractViewDelegate

-(void)didUnsubscribeToken {
    
    if ([self.delegate respondsToSelector:@selector(didUnsubscribeFromDeletedContract:)]) {
        [self.delegate didUnsubscribeFromDeletedContract:self.token];
    }
}

#pragma mark - TokenDetailOutput


-(void)showUnsubscribeContractScreen {
    
    NoContractView* noContractView = [self getNoContractView];
    noContractView.delegate = self;
    
    [self.view addSubview:noContractView];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(noContractViewTopOffset, noContractViewLeading, noContractViewBottomOffset, noContractViewTrailing);
    
    [noContractView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBarView.bottom).with.offset(padding.top);
        make.left.equalTo(self.view).with.offset(padding.left);
        make.bottom.equalTo(self.view).with.offset(padding.bottom);
        make.right.equalTo(self.view).with.offset(padding.right);
    }];
    
    self.navigationShareButton.hidden = YES;
}

#pragma mark - Actions

- (IBAction)actionShare:(id) sender {
	[self.delegate didShareTokenButtonPressed];
}

- (IBAction)actionBack:(id) sender {
	[self.delegate didBackPressed];
}

- (void)refreshFromRefreshControl {

	[self.delegate didPullToUpdateToken:self.token];
}

#pragma mark - Output

- (void)updateControls {

	[self refreshTable];
}

#pragma mark - TokenDetailDisplayDataManagerDelegate

- (void)didPressedInfoActionWithToken:(Contract *) aToken {
	[self.delegate showAddressInfoWithSpendable:aToken];
}

- (void)didPressTokenAddressControlWithToken:(Contract *) aToken {
	[self.delegate didShowTokenAddressControlWith:aToken];
}

- (void)didPressHistoryItemForToken:( id <HistoryElementProtocol>) item {
    [self.delegate didSelectTokenHistoryItem:item];
}

- (void)needShowHeader {
	if (self.heightConsctaintForHeaderView.constant == HeightForHeaderView) {
		return;
	}

	self.heightConsctaintForHeaderView.constant = HeightForHeaderView;
	[self.headerVIew showAnimation];
}

- (void)needHideHeader {
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

- (void)updateHeader:(Contract *) token {

	self.availableBalanceLabel.text = [NSString stringWithFormat:@"%@ %@", token.balanceString ? : @"", token.symbol ? : @""];
}

- (void)refreshTable {
    
    __weak __typeof(self)weakSelf = self;
	dispatch_async (dispatch_get_main_queue (), ^{
        
        if (weakSelf.token.historyArray.count > 0) {
            weakSelf.noTransactionView.hidden = YES;
        } else {
            weakSelf.noTransactionView.hidden = NO;
        }
        
		[weakSelf.refreshControl endRefreshing];
		[weakSelf.tableView reloadData];
	});
}

@end
