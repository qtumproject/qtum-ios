//
//  TokenDetailsViewControllerLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 24.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "TokenDetailsViewControllerLight.h"
#import "HistoryHeaderVIew.h"
#import "NoContractView.h"
#import "Masonry.h"

@interface TokenDetailsViewControllerLight () <TokenDetailDisplayDataManagerDelegate, NoContractViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *noTransactionTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *shortInfoHeader;
@property (weak, nonatomic) IBOutlet UILabel *availibleBalanceShortInfoLabel;
@property (weak, nonatomic) IBOutlet UIView *navigationBarView;
@property (weak, nonatomic) UIView *refreshBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightForBlueView;
@property (weak, nonatomic) IBOutlet UIView *noTransactionView;
@property (weak, nonatomic) IBOutlet UIButton *navigationShareButton;
@property (weak, nonatomic) IBOutlet UIButton *navigationAddressesButton;
@property (assign, nonatomic) BOOL isFirstTimeUpdate;


@end

static NSInteger noContractViewTopOffset = 0;
static NSInteger noContractViewBottomOffset = 0;
static NSInteger noContractViewLeading = 0;
static NSInteger noContractViewTrailing = 0;

@implementation TokenDetailsViewControllerLight

@synthesize delegate, token, source;

- (void)viewDidLoad {

	[super viewDidLoad];

	[self configTableView];
    [self configLocalization];
    self.isFirstTimeUpdate = YES;
	self.titleLabel.text = (self.token.name && self.token.name.length > 0) ? self.token.name : NSLocalizedString(@"Token Details", nil);
    [self updateHeader:token];
	[self reloadHistorySource];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.isFirstTimeUpdate) {
        [self.source setupFething];
        self.isFirstTimeUpdate = NO;
    }
}

- (void)updateHeader:(Contract *) token {
    
    self.availibleBalanceShortInfoLabel.text = [NSString stringWithFormat:@"%@ %@", token.shortBalanceString ? : @"", token.symbol ? : @""];
}
#pragma mark - Configuration

- (void)configTableView {

	self.source.delegate = self;
    self.source.tableView = self.tableView;
    self.source.emptyPlaceholderView = self.noTransactionView;
	self.tableView.dataSource = self.source;
	self.tableView.delegate = self.source;
	[self.tableView reloadData];
	UINib *sectionHeaderNib = [UINib nibWithNibName:@"HistoryTableHeaderViewLight" bundle:nil];
	[self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    
}

-(void)configLocalization {
    
    self.noTransactionTextLabel.text = NSLocalizedString(@"No transactions available yet", @"");
}

#pragma mark - Pivate Methods

- (NoContractView *)getNoContractView {
    
    NoContractView *noContractView = [[[NSBundle mainBundle] loadNibNamed:@"NoContractViewLight" owner:self options:nil] objectAtIndex:0];
    return noContractView;
}

- (void)refreshFromRefreshControl {

	[self.delegate didPullToUpdateToken:self.token];
}

- (void)refreshTable {

    __weak __typeof(self)weakSelf = self;
    dispatch_async (dispatch_get_main_queue (), ^{
        
        [weakSelf.source reloadWithFeching];
        [weakSelf.tableView reloadData];
    });
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
    self.navigationAddressesButton.hidden = YES;
}

- (void)reloadHistorySource {
    
    [self refreshTable];
}

- (void)reloadTokenInfo {
    
    __weak __typeof(self)weakSelf = self;
    dispatch_async (dispatch_get_main_queue (), ^{
        [weakSelf updateHeader:weakSelf.token];
        [weakSelf.tableView reloadData];
    });
}

- (void)conndectionFailed {
    
}


- (void)conndectionSuccess {
    
}


- (void)failedToUpdateHistory {
    
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

- (void)refreshTableViewDataFromStart {
    [self.delegate reloadContractHistoryOfToken:self.token];
}

- (void)refreshTableViewDataWithPage:(NSInteger) page {
    [self.delegate refreshContractHistoryOfToken:self.token withPage:page];
}

#pragma mark - Updating depend on scroll

- (void)updateWithOffsetShortInfoView:(CGFloat) offset {
    
    CGFloat startFadingPoint = offset - 200;  //DETERMINE POINT WHEN SHOUD START FAIDING WITHOFFSET
    
    CGFloat fullAlphaLastPoin; //DETERMINE POINT WHEN OFFSET SHOUD START FAIDING TO 0
    CGFloat emptyAlphaFirstPoiny; //DETERMINE POINT WHEN OFFSET SHOUD BE 0
    
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
