//
//  MainViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MainViewController.h"
#import "HistoryTableViewCell.h"
#import "BlockchainInfoManager.h"
#import "NewPaymentViewController.h"
#import "RecieveViewController.h"
#import "HistoryElement.h"
#import "QRCodeViewController.h"
#import "ApplicationCoordinator.h"
#import "GradientViewWithAnimation.h"
#import "WalletHistoryDelegateDataSource.h"
#import "WalletCoordinator.h"
#import "HistoryHeaderVIew.h"

@interface MainViewController () <QRCodeViewControllerDelegate>

@property (nonatomic) NSDictionary *dictionaryForNewPayment;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet GradientViewWithAnimation *topBoardView;
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
//    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // get all dataForScreen
    if (self.isFirstTimeUpdate) {
        self.isFirstTimeUpdate = NO;
        [self getBalanceLocal:YES];
        [self getHistoryLocal:NO fromStart:YES];
    } else {
        [self getBalanceLocal:YES];
        [self getHistoryLocal:YES fromStart:NO];
    }
}

#pragma mark - Configuration

-(void)configRefreshControl{
    self.refreshControl = [[UIRefreshControl alloc]init];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshButtonWasPressed:) forControlEvents:UIControlEventValueChanged];
    
    //creating bacground for refresh controll
    CGRect frame = self.tableView.bounds;
    frame.origin.y = -frame.size.height;
    UIView *refreshBackgroundView = [[UIView alloc]initWithFrame:frame];
    refreshBackgroundView.backgroundColor = [UIColor colorWithRed:63/255.0f green:56/255.0f blue:196/255.0f alpha:1.0f];
    [self.tableView insertSubview:refreshBackgroundView atIndex:0];
    
}

-(void)configAdressLabel{
    NSString* keyString = [AppSettings sharedInstance].isMainNet ? [WalletManager sharedInstance].getCurrentWallet.getRandomKey.address.string : [WalletManager sharedInstance].getCurrentWallet.getRandomKey.addressTestnet.string;
    self.adressLabel.text = keyString;
}

-(void)configTableView{
    self.tableView.tableFooterView = [UIView new];
    CGFloat offset = self.customNavigationBar.frame.size.height;
    self.tableView.contentInset =
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(offset, 0, 0, 0);
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
            self.customNavigationBar.layer.backgroundColor = [UIColor colorWithRed:63/255.0f green:56/255.0f blue:196/255.0f alpha:1.0].CGColor;
        }];

    }
}
- (void)fadeOutNavigationBar{
    if (!self.isNavigationBarFadeout) {
        self.isNavigationBarFadeout = YES;
        self.customNavigationBar.layer.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0].CGColor;
        [UIView animateWithDuration:0.2 animations:^{
            self.customNavigationBar.layer.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0].CGColor;
        }];
    }
}

#pragma mark - Private Methods

-(void)updateDataLocal:(BOOL)isLocal{
    self.isFirstTimeUpdate = NO;
    [self.refreshControl endRefreshing];
    if (self.balanceLoaded && self.historyLoaded) {
        [self getBalanceLocal:isLocal];
        [self getHistoryLocal:isLocal fromStart:NO];
    }
}

#pragma mark - Methods

- (void)getBalanceLocal:(BOOL)isLocal{
    self.balanceLoaded = NO;
    [self.delegate refreshTableViewBalanceLocal:isLocal];
}

- (void)getHistoryLocal:(BOOL)isLocal fromStart:(BOOL) flag{
    self.historyLoaded = NO;
    [self.delegate refreshTableViewDataLocal:isLocal fromStart:flag];
}

-(void)reloadTableView{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });

    self.historyLoaded = YES;
    if (self.balanceLoaded && self.historyLoaded) {
        [SVProgressHUD dismiss];
    }
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

-(void)startLoading{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![SVProgressHUD isVisible]) {
            [SVProgressHUD show];
        }
    });
}

-(void)failedToGetData{
    self.historyLoaded = YES;
    if (self.balanceLoaded && self.historyLoaded) {
        [SVProgressHUD showErrorWithStatus:@"Some error"];
    }
}
-(void)failedToGetBalance{
    self.balanceLoaded = YES;
    if (self.balanceLoaded && self.historyLoaded) {
        [SVProgressHUD showErrorWithStatus:@"Some error"];
    }
}

#pragma mark - QRCodeViewControllerDelegate

- (void)qrCodeScanned:(NSDictionary *)dictionary{
    [self.delegate qrCodeScannedWithDict:dictionary];
}

#pragma mark - Actions

- (IBAction)actionRecive:(id)sender {
    [self performSegueWithIdentifier:@"MaintToRecieve" sender:self];
}


- (IBAction)refreshButtonWasPressed:(id)sender{
    [self.delegate setLastPageForHistory:0 needIncrease:NO];
    [self updateDataLocal:NO];
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
