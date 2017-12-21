//
//  TokenDetailsViewControllerLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 24.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "TokenDetailsViewControllerLight.h"
#import "HistoryHeaderVIew.h"

@interface TokenDetailsViewControllerLight () <TokenDetailDisplayDataManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *noTransactionTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *shortInfoHeader;
@property (weak, nonatomic) IBOutlet UILabel *availibleBalanceShortInfoLabel;
@property (weak, nonatomic) IBOutlet UIView *navigationBarView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) UIView *refreshBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForBlueView;
@property (weak, nonatomic) IBOutlet UIView *noTransactionView;


@end

@implementation TokenDetailsViewControllerLight

@synthesize delegate, token, source;

- (void)viewDidLoad {

	[super viewDidLoad];

	[self configTableView];
	[self configRefreshControl];
    [self configLocalization];

	self.titleLabel.text = (self.token.name && self.token.name.length > 0) ? self.token.name : NSLocalizedString(@"Token Details", nil);

	[self updateControls];
    [self.delegate didPullToUpdateToken:self.token];
}

#pragma mark - Configuration

- (void)configTableView {

	self.source.delegate = self;
	self.tableView.dataSource = self.source;
	self.tableView.delegate = self.source;
	[self.tableView reloadData];
	UINib *sectionHeaderNib = [UINib nibWithNibName:@"HistoryTableHeaderViewLight" bundle:nil];
	[self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    
}

- (void)configRefreshControl {

	UIView *refreshView = [[UIView alloc] initWithFrame:CGRectMake (0, 0, 0, 0)];
	[self.tableView addSubview:refreshView];

	self.refreshControl = [[UIRefreshControl alloc] init];
	self.refreshControl.tintColor = [UIColor whiteColor];
	[refreshView addSubview:self.refreshControl];
	[self.refreshControl addTarget:self action:@selector (refreshFromRefreshControl) forControlEvents:UIControlEventValueChanged];
}

-(void)configLocalization {
    
    self.noTransactionTextLabel.text = NSLocalizedString(@"No transactions available yet", @"");
}

- (void)refreshFromRefreshControl {

	[self.delegate didPullToUpdateToken:self.token];
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

#pragma mark - Update

- (void)updateControls {

    dispatch_async (dispatch_get_main_queue (), ^{
        self.availibleBalanceShortInfoLabel.text = [NSString stringWithFormat:@"%@ %@", token.balanceString ? : @"", token.symbol ? : @""];
        [self refreshTable];
    });

}

#pragma mark - Actions

- (IBAction)actionShare:(id) sender {
	[self.delegate didShareTokenButtonPressed];
}

- (IBAction)actionBack:(id) sender {
	[self.delegate didBackPressed];
}

- (IBAction)actionPlus:(id) sender {
	[self.delegate showAddressInfoWithSpendable:self.token];
}

- (IBAction)didPressTokenAddressControl:(id) sender {
	[self.delegate didShowTokenAddressControlWith:self.token];
}

#pragma mark - TokenDetailDisplayDataManagerDelegate

- (void)updateWithYOffset:(CGFloat) offset {

	[self updateWithOffsetNavBarView:offset];
	[self updateWithOffsetShortInfoView:offset];
}

- (void)didPressHistoryItemForToken:( id <HistoryElementProtocol>) item {
    [self.delegate didSelectTokenHistoryItem:item];
}

#pragma mark - Updating depend on scroll

- (void)updateWithOffsetShortInfoView:(CGFloat) offset {

	CGFloat startFadingPoint = offset - 200;  //DETERMINE POINT WHEN SHOUD START FAIDING WITHOFFSET

	CGFloat fullAlphaLastPoin; //DETERMINE POINT WHEN OFFSET SHOUD START FAIDING TO 0
	CGFloat emptyAlphaFirstPoiny;//DETERMINE POINT WHEN OFFSET SHOUD BE 0

	fullAlphaLastPoin = self.shortInfoHeader.frame.origin.y;
	emptyAlphaFirstPoiny = self.shortInfoHeader.frame.origin.y + self.shortInfoHeader.frame.size.height;

	self.shortInfoHeader.alpha = 1 - (fullAlphaLastPoin - startFadingPoint) / (emptyAlphaFirstPoiny - fullAlphaLastPoin);

	self.heightForBlueView.constant = 240.0f - offset;
}

- (void)updateWithOffsetNavBarView:(CGFloat) offset {

	CGFloat startFadingPoint = offset - 100;  //DETERMINE POINT WHEN SHOUD START FAIDING WITHOFFSET

	CGFloat fullAlphaLastPoin; //DETERMINE POINT WHEN OFFSET SHOUD START FAIDING TO 0
	CGFloat emptyAlphaFirstPoiny;//DETERMINE POINT WHEN OFFSET SHOUD BE 0

	fullAlphaLastPoin = self.navigationBarView.frame.origin.y;
	emptyAlphaFirstPoiny = self.navigationBarView.frame.origin.y + self.navigationBarView.frame.size.height;

	self.navigationBarView.alpha = (fullAlphaLastPoin - startFadingPoint) / (emptyAlphaFirstPoiny - fullAlphaLastPoin);
}

@end
