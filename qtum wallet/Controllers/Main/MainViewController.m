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

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource, QRCodeViewControllerDelegate>

@property (nonatomic) NSDictionary *dictionaryForNewPayment;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) BOOL balanceLoaded;
@property (nonatomic) BOOL historyLoaded;
@property (nonatomic) NSArray *historyArray;

- (IBAction)refreshButtonWasPressed:(id)sender;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.balanceLabel.text = @"0";
    
    self.historyLoaded = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // get all dataForScreen
    [self refreshButtonWasPressed:nil];
}

- (IBAction)refreshButtonWasPressed:(id)sender
{
    [SVProgressHUD show];
    
    [self getBalance];
    [self getHistory];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryTableViewCell"];
    if (!cell) {
        cell = [[HistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HistoryTableViewCell"];
    }
    
    HistoryElement *element = self.historyArray[indexPath.row];
    cell.historyElement = element;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.historyArray.count;
}

#pragma mark - Methods

- (void)getBalance
{
    self.balanceLoaded = NO;
    
    __weak typeof(self) weakSelf = self;
    [BlockchainInfoManager getBalanceForAllAddresesWithSuccessHandler:^(double responseObject) {
        weakSelf.balanceLabel.text = [NSString stringWithFormat:@"%lf", responseObject];
        weakSelf.balanceLoaded = YES;
        
        if (weakSelf.balanceLoaded && weakSelf.historyLoaded) {
            [SVProgressHUD dismiss];
        }
    } andFailureHandler:^(NSError *error, NSString *message) {
        weakSelf.balanceLoaded = YES;
        if (weakSelf.balanceLoaded && weakSelf.historyLoaded) {
            [SVProgressHUD showErrorWithStatus:@"Some error"];
        }
    }];
}

- (void)getHistory
{
    self.historyLoaded = NO;
    
    __weak typeof(self) weakSelf = self;
    [BlockchainInfoManager getHistoryForAllAddresesWithSuccessHandler:^(NSArray *responseObject) {
        weakSelf.historyLoaded = YES;
        weakSelf.historyArray = responseObject;
        [weakSelf.tableView reloadData];
        
        if (weakSelf.balanceLoaded && weakSelf.historyLoaded) {
            [SVProgressHUD dismiss];
        }
        NSLog(@"%@", responseObject);
    } andFailureHandler:^(NSError *error, NSString *message) {
        weakSelf.historyLoaded = YES;
        if (weakSelf.balanceLoaded && weakSelf.historyLoaded) {
            [SVProgressHUD showErrorWithStatus:@"Some error"];
        }
    }];
}

#pragma mark - QRCodeViewControllerDelegate

- (void)qrCodeScanned:(NSDictionary *)dictionary
{
    self.dictionaryForNewPayment = dictionary;
}

- (void)showNextVC
{
    [self performSegueWithIdentifier:@"FromMainToNewPayment" sender:self];
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
    
    if ([segueID isEqualToString:@"MainToQrCode"]) {
        QRCodeViewController *vc = (QRCodeViewController *)segue.destinationViewController;
        
        vc.delegate = self;
    }
}
@end
