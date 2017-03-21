//
//  MainViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

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


@property (nonatomic) BOOL balanceLoaded;
@property (nonatomic) BOOL historyLoaded;

- (IBAction)refreshButtonWasPressed:(id)sender;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.wigetBalanceLabel.text =
    self.balanceLabel.text = @"0";
    self.historyLoaded = YES;
    self.balanceLoaded = YES;
    
    [self configTableView];
    [self configRefreshControl];
    [self configAdressLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.topBoardView startAnimating];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // get all dataForScreen
    [self refreshButtonWasPressed:nil];
}

#pragma mark - Configuration

-(void)configRefreshControl{
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshButtonWasPressed:) forControlEvents:UIControlEventValueChanged];
}

-(void)configAdressLabel{
    self.adressLabel.text = [WalletManager sharedInstance].getCurrentWallet.getRandomKey.address.string;
}

-(void)configTableView{
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    CGFloat offset = self.topBoardView.frame.size.height + self.quickInfoBoard.frame.size.height;
    self.tableView.contentInset =
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(offset, 0, 0, 0);
    self.tableView.dataSource = self.delegateDataSource;
}

- (IBAction)refreshButtonWasPressed:(id)sender
{
    [self.refreshControl endRefreshing];
    if (self.balanceLoaded && self.historyLoaded) {
        [SVProgressHUD show];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self getBalance];
            [self getHistory];
        });
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger yOffset = scrollView.contentOffset.y < scrollView.contentInset.top * -1 ? scrollView.contentInset.top : scrollView.contentOffset.y * -1;
    
    [self calculatePositionForView:self.topBoardView withScrollOffset:yOffset withLimetedYValue:nil];
    [self calculatePositionForView:self.quickInfoBoard withScrollOffset:yOffset withLimetedYValue:@(self.customNavigationBar.frame.size.height)];
    [self calculatePositionForView:self.topSubstrateView withScrollOffset:yOffset withLimetedYValue:nil];
    
    if (scrollView.contentOffset.y < -350) {
        [self refreshButtonWasPressed:nil];
    }

    [self setupNavigationBarPerformance];
}

-(void)calculatePositionForView:(UIView*)view withScrollOffset:(NSInteger)offset withLimetedYValue:(NSNumber*)value{
    static CGFloat previousOffset;
    CGRect rect = view.frame;
    if (value) {
        if (offset - rect.size.height < value.integerValue) {
            rect.origin.y = value.integerValue;
        }else if (offset >= rect.size.height + value.integerValue) {
            rect.origin.y = offset - rect.size.height;
        }
    }else {
        rect.origin.y += previousOffset + offset;
    }
    previousOffset = - offset;
    view.frame = rect;
}

-(void)setupNavigationBarPerformance{
    BOOL flag = self.quickInfoBoard.frame.origin.y <= self.customNavigationBar.frame.size.height;
    self.customNavigationBar.backgroundColor = flag ? [UIColor colorWithRed:54/255. green:85/255. blue:200/255. alpha:1] : [UIColor clearColor];
    self.shortInfoView.hidden = !flag;
}

#pragma mark - Methods

- (void)getBalance
{
    self.balanceLoaded = NO;
    [self.delegate refreshTableViewBalance];
}

- (void)getHistory
{
    self.historyLoaded = NO;
    [self.delegate refreshTableViewData];
}

-(void)reloadTableView{
    [self.tableView reloadData];
    self.historyLoaded = YES;
    if (self.balanceLoaded && self.historyLoaded) {
        [SVProgressHUD dismiss];
    }
}

-(void)setBalance{
    self.balanceLoaded = YES;
    if (self.balanceLoaded && self.historyLoaded) {
        [SVProgressHUD dismiss];
    }
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

#pragma merk - Seque

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueID = segue.identifier;
    
    if ([segueID isEqualToString:@"FromMainToNewPayment"]) {
        NewPaymentViewController *vc = (NewPaymentViewController *)segue.destinationViewController;
        
        vc.currentBalance = self.balanceLabel.text;
        vc.dictionary = self.dictionaryForNewPayment;
        self.dictionaryForNewPayment = nil;
    }
    
    if ([segueID isEqualToString:@"MaintToRecieve"]) {
        RecieveViewController *vc = (RecieveViewController *)segue.destinationViewController;
        
        vc.balance = self.balanceLabel.text;
    }
    
    if ([segueID isEqualToString:@"qrCode"]) {
        QRCodeViewController *vc = (QRCodeViewController *)segue.destinationViewController;
        vc.delegate = self;
    }
}

-(void)unwindForSegue:(UIStoryboardSegue *)unwindSegue towardsViewController:(UIViewController *)subsequentVC{
    
}

@end
