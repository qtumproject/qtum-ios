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

CGFloat const HeaderHeightShowed = 50.0f;

@interface MainViewController () <QRCodeViewControllerDelegate>

@property (nonatomic) NSDictionary *dictionaryForNewPayment;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *quickInfoBoard;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBoardQuckBoardOffset;
@property (weak, nonatomic) IBOutlet UIView *customNavigationBar;
@property (weak, nonatomic) IBOutlet UIView *topSubstrateView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UIView *shortInfoView;
@property (assign, nonatomic) BOOL canNewRequest;
@property (assign, nonatomic) BOOL isNavigationBarFadeout;
@property (assign, nonatomic) BOOL isFirstTimeUpdate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *availabelLabel;
@property (weak, nonatomic) IBOutlet UILabel *uncorfirmedLabel;
@property (weak, nonatomic) IBOutlet UILabel *unconfirmedTextLabel;

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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

- (void)fadeInNavigationBar{
    if (self.isNavigationBarFadeout) {
        self.isNavigationBarFadeout = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.customNavigationBar.layer.backgroundColor = customBlueColor().CGColor;
        }];
    }
}

- (void)fadeOutNavigationBar{
    if (!self.isNavigationBarFadeout) {
        self.isNavigationBarFadeout = YES;
        self.customNavigationBar.layer.backgroundColor = customBlueColor().CGColor;
        [UIView animateWithDuration:0.2 animations:^{
            self.customNavigationBar.layer.backgroundColor = customBlueColor().CGColor;
        }];
    }
}

- (void)needShowHeader{
    if (self.headerHeightConstraint.constant == HeaderHeightShowed) {
        return;
    }
    
    self.headerHeightConstraint.constant = HeaderHeightShowed;
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
        self.historyLoaded = YES;
        if (self.balanceLoaded && self.historyLoaded) {
            [SVProgressHUD dismiss];
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

-(void)setBalance{
    self.balanceLoaded = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    //[self.tableView reloadData];
    if (self.balanceLoaded && self.historyLoaded) {
        [SVProgressHUD dismiss];
    }
}

-(void)startLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![SVProgressHUD isVisible]) {
            [SVProgressHUD show];
        }
    });
}

-(void)stopLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
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
