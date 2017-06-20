//
//  MainViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.11.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MainViewController.h"
#import "HistoryTableViewCell.h"
#import "NewPaymentViewController.h"
#import "RecieveViewController.h"
#import "HistoryElement.h"
#import "QRCodeViewController.h"
#import "ApplicationCoordinator.h"
#import "GradientViewWithAnimation.h"
#import "WalletHistoryDelegateDataSource.h"
#import "WalletCoordinator.h"
#import "HistoryHeaderVIew.h"
#import "ViewWithAnimatedLine.h"

CGFloat const HeaderHeightShowed = 50.0f;

@interface MainViewController () <QRCodeViewControllerDelegate>

@property (nonatomic) NSDictionary *dictionaryForNewPayment;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *customNavigationBar;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (assign, nonatomic) BOOL canNewRequest;
@property (assign, nonatomic) BOOL isNavigationBarFadeout;
@property (assign, nonatomic) BOOL isFirstTimeUpdate;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingForLineConstraint;
@property (weak, nonatomic) IBOutlet ViewWithAnimatedLine *headerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *availabelLabel;
@property (weak, nonatomic) IBOutlet UILabel *uncorfirmedLabel;
@property (weak, nonatomic) IBOutlet UILabel *unconfirmedTextLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *availableTextTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *availableValueTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topForTableConstraint;
@property (weak, nonatomic) IBOutlet UIView *viewForHeaderInSecondSection;

@property (nonatomic) BOOL balanceLoaded;
@property (nonatomic) BOOL historyLoaded;

- (IBAction)refreshButtonWasPressed:(id)sender;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.wigetBalanceLabel.text =
    self.balanceLabel.text = @"0";

    self.isFirstTimeUpdate = YES;
    self.canNewRequest = YES;
    
    [self configTableView];
    [self configRefreshControl];
    self.navigationController.navigationBar.translucent = NO;
    [self configAdressLabel];
    
    [self.headerView setRightConstraint:self.trailingForLineConstraint];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    WalletHistoryDelegateDataSource *source = (WalletHistoryDelegateDataSource *)self.tableView.dataSource;
    [self reloadHeader:source.wallet];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // get all dataForScreen
    if (self.isFirstTimeUpdate) {
        [self.delegate reloadTableViewData];
        self.isFirstTimeUpdate = NO;
    }
}

#pragma mark - Configuration

-(void)configRefreshControl{
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.tintColor = customBlackColor();
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshButtonWasPressed:) forControlEvents:UIControlEventValueChanged];
    
    //creating bacground for refresh controll
    CGRect frame = self.tableView.bounds;
    frame.origin.y = -frame.size.height;
    UIView *refreshBackgroundView = [[UIView alloc]initWithFrame:frame];
    refreshBackgroundView.backgroundColor = customBlueColor();
    [self.tableView insertSubview:refreshBackgroundView atIndex:0];
}

-(void)configAdressLabel{
    NSString* keyString = [AppSettings sharedInstance].isMainNet ? [WalletManager sharedInstance].getCurrentWallet.getRandomKey.address.string : [WalletManager sharedInstance].getCurrentWallet.getRandomKey.addressTestnet.string;
    self.adressLabel.text = keyString;
}

-(void)configTableView{
    self.tableView.tableFooterView = [UIView new];
    self.tableView.dataSource = self.delegateDataSource;
    self.tableView.delegate = self.delegateDataSource;
    self.delegateDataSource.tableView = self.tableView;
    self.delegateDataSource.controllerDelegate = self;
    
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"HistoryTableHeaderView" bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
}

- (void)needShowHeader{
    if (self.headerHeightConstraint.constant == HeaderHeightShowed) {
        return;
    }
    
    self.headerHeightConstraint.constant = HeaderHeightShowed;
    [self.headerView showAnimation];
}

- (void)needShowHeaderForSecondSeciton {
    self.viewForHeaderInSecondSection.hidden = NO;
}
- (void)needHideHeaderForSecondSeciton {
    self.viewForHeaderInSecondSection.hidden = YES;
}

- (void)needHideHeader{
    if (self.headerHeightConstraint.constant == 0.0f) {
        return;
    }
    
    self.headerHeightConstraint.constant = 0;
}

#pragma mark - Private Methods


#pragma mark - Methods

- (void)getBalanceLocal:(BOOL)isLocal{
    self.balanceLoaded = NO;
    [self.delegate refreshTableViewBalanceLocal:isLocal];
}

-(void)reloadTableView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        WalletHistoryDelegateDataSource *source = (WalletHistoryDelegateDataSource *)self.tableView.dataSource;
        [self reloadHeader:source.wallet];
        self.historyLoaded = YES;
        if (self.balanceLoaded && self.historyLoaded) {
            [[PopUpsManager sharedInstance] dismissLoader];
        }
    });
}

-(void)reloadHistorySection {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSRange range = NSMakeRange(1, 1);
        NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.tableView reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
    });
}

- (void)reloadHeader:(id <Spendable>)wallet{
    
    BOOL haveUncorfirmed = wallet.unconfirmedBalance != 0.0f;
    self.availableTextTopConstraint.constant = haveUncorfirmed ? 10.0f : 17.0f;
    self.availableValueTopConstraint.constant = haveUncorfirmed ? 8.0f : 15.0f;
    
    self.unconfirmedTextLabel.hidden =
    self.uncorfirmedLabel.hidden = !haveUncorfirmed;
    
    self.uncorfirmedLabel.text = [NSString stringWithFormat:@"%f",wallet.unconfirmedBalance];
    self.availabelLabel.text = [NSString stringWithFormat:@"%f",wallet.balance];
}

-(void)setBalance{
    self.balanceLoaded = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        WalletHistoryDelegateDataSource *source = (WalletHistoryDelegateDataSource *)self.tableView.dataSource;
        [self reloadHeader:source.wallet];
    });
    if (self.balanceLoaded && self.historyLoaded) {
        [[PopUpsManager sharedInstance] dismissLoader];
    }
}

-(void)startLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[PopUpsManager sharedInstance] showLoaderPopUp];
    });
}

-(void)stopLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[PopUpsManager sharedInstance] dismissLoader];
    });
}

-(void)failedToGetData{
    self.historyLoaded = YES;
    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Some error", "")];
}
-(void)failedToGetBalance{
    self.balanceLoaded = YES;
    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Some error", "")];

}

#pragma mark - QRCodeViewControllerDelegate

- (void)qrCodeScanned:(NSDictionary *)dictionary{
    [self.delegate qrCodeScannedWithDict:dictionary];
}

#pragma mark - Paginationalable

-(void)setCurrentPage:(NSInteger) page{
    
}

-(void)setNumberPages:(NSInteger) number{
    
}

#pragma mark - Actions

- (IBAction)actionRecive:(id)sender {
    [self performSegueWithIdentifier:@"MaintToRecieve" sender:self];
}

- (IBAction)refreshButtonWasPressed:(id)sender{

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
    });
    [self.delegate reloadTableViewData];
}

#pragma merk - Seque

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueID = segue.identifier;
    if ([segueID isEqualToString:@"qrCode"]) {
        QRCodeViewController *vc = (QRCodeViewController *)segue.destinationViewController;
        vc.delegate = self;
    }
}

-(void)unwindForSegue:(UIStoryboardSegue *)unwindSegue towardsViewController:(UIViewController *)subsequentVC{
    
}

@end
