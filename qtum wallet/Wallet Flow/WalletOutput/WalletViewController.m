//
//  MainViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.11.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "WalletViewController.h"
#import "LoaderPopUpViewController.h"

@interface WalletViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityTextLabel;

@property (nonatomic) NSDictionary *dictionaryForNewPayment;

@property (assign, nonatomic) BOOL balanceLoaded;
@property (assign, nonatomic) BOOL historyLoaded;
@property (assign, nonatomic) BOOL isFirstTimeUpdate;
@property (weak, nonatomic) IBOutlet UIView *emptyPlaceholderView;
@property (weak, nonatomic) LoaderPopUpViewController* loader;
@property (assign, nonatomic) BOOL isLoading;

@property (nonatomic) id <Spendable> wallet;

@end

static const CGFloat blanceRoundingCount = 8;

@implementation WalletViewController

- (void)viewDidLoad {
    
	[super viewDidLoad];

	self.isFirstTimeUpdate = YES;

	[self configTableView];
	[self configHeaderBacground];
    [self configLocalization];
}

- (void)viewWillAppear:(BOOL) animated {

	[super viewWillAppear:animated];

	[self reloadHeader:self.wallet];
}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    if (self.isFirstTimeUpdate) {
        [self.tableSource setupFething];
        [self.tableView reloadData];
        self.isFirstTimeUpdate = NO;
    }
    [self.loader reloadLoaderAnimation];
}

#pragma mark - Configuration

- (void)configLocalization {
    
    self.titleTextLabel.text = NSLocalizedString(@"My Wallet", @"Wallet Controllers Title");
    self.activityTextLabel.text = NSLocalizedString(@"Activity", @"Wallet Controllers Activity");
}

- (void)configHeaderBacground {
}

- (void)configTableView {

	self.tableView.tableFooterView = [UIView new];
	self.tableView.dataSource = self.tableSource;
	self.tableView.delegate = self.tableSource;
	self.tableSource.emptyPlacehodlerView = self.emptyPlaceholderView;
	self.tableSource.tableView = self.tableView;
	self.tableSource.controllerDelegate = self;
}

#pragma mark - Private Methods


#pragma mark - Methods

- (void)reloadHeader:(id <Spendable>) wallet {
    
    __weak __typeof(self) weakSelf = self;
    dispatch_async (dispatch_get_main_queue (), ^{
        
        BOOL haveUncorfirmed = ![SLocator.walletBalanceFacadeService.lastUnconfirmedBalance isEqualToInt:0];
        
        weakSelf.availableTextTopConstraint.constant = haveUncorfirmed ? 10.0f : 17.0f;
        weakSelf.availableValueTopConstraint.constant = haveUncorfirmed ? 8.0f : 15.0f;
        
        weakSelf.unconfirmedTextLabel.hidden =
        weakSelf.uncorfirmedLabel.hidden = !haveUncorfirmed;
        
        weakSelf.uncorfirmedLabel.text = [NSString stringWithFormat:@"%@ %@", [SLocator.walletBalanceFacadeService.lastUnconfirmedBalance roundedNumberWithScale:blanceRoundingCount], NSLocalizedString(@"QTUM", nil)];
        weakSelf.availabelLabel.text = [NSString stringWithFormat:@"%@ %@", [SLocator.walletBalanceFacadeService.lastBalance roundedNumberWithScale:blanceRoundingCount], NSLocalizedString(@"QTUM", nil)];
    });
}

- (void)startLoading {

    [self stopLoading];
    
    __weak __typeof(self)weakSelf = self;
    
	dispatch_async (dispatch_get_main_queue (), ^{
        
        if (!weakSelf.isLoading) {
            LoaderPopUpViewController *loader = [SLocator.popupService showLoaderPopUpInView:self.view];
            weakSelf.loader = loader;
            weakSelf.isLoading = YES;
        }
	});
}

- (void)stopLoading {
    
    __weak __typeof(self)weakSelf = self;

    dispatch_async (dispatch_get_main_queue (), ^{
        if (weakSelf.isLoading) {
            [SLocator.popupService dismissLoader:weakSelf.loader completion:^{
                weakSelf.isLoading = NO;
            }];
        }
    });
}

- (void)failedToUpdateHistory {
    
}

- (void)conndectionFailed {
    [self.tableSource failedConnection];
}

- (void)conndectionSuccess {
    [self.tableSource reconnect];
}

- (void)reloadHistorySource {
    [self.tableSource reloadWithFeching];
}

#pragma mark - Actions

- (IBAction)actionQRCode:(id) sender {
    [self.delegate didShowQRCodeScan];
}

- (IBAction)actionShowAddress:(id) sender {
    [self.delegate didShowAddressControl];
}

#pragma mark - TableSourceDelegate

- (void)needShowHeader:(CGFloat) percent {
}

- (void)needHideHeader:(CGFloat) percent {
}

- (void)needShowHeaderForSecondSeciton {
    self.viewForHeaderInSecondSection.hidden = NO;
}

- (void)needHideHeaderForSecondSeciton {
    self.viewForHeaderInSecondSection.hidden = YES;
}

@end
