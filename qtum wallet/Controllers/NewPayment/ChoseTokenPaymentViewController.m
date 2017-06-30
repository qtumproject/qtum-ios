//
//  ChoseTokenPaymentViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 25.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "ChoseTokenPaymentViewController.h"
#import "ChoseTokenPaymentCell.h"

@interface ChoseTokenPaymentViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChoseTokenPaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tokens = [[ContractManager sharedInstance] allActiveTokens];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenDidChange) name:kTokenDidChange object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private Methods

-(void)tokenDidChange {
    self.tokens = [[ContractManager sharedInstance] allActiveTokens];
    if (!self.tokens.count) {
        [self.navigationController popViewControllerAnimated:NO];
    } else {
        __weak __typeof(self)weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }
}

-(void)updateTable {
    
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.tokens = [[ContractManager sharedInstance] allActiveTokens];
        [weakSelf.tableView reloadData];
    });
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 46;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Contract* token = self.tokens[indexPath.row];
    if ([token isEqual:self.activeToken]) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.activeToken = nil;
        [self.delegate resetToDefaults];
    } else {
        [self.delegate didSelectTokenIndexPath:indexPath withItem:token];

    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate didDeselectTokenIndexPath:indexPath withItem:self.tokens[indexPath.row]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tokens.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChoseTokenPaymentCell* cell = [tableView dequeueReusableCellWithIdentifier:choseTokenPaymentCellIdentifire];
    cell.tokenName.text = self.tokens[indexPath.row].localName;
    cell.mainBalance.text = [NSString stringWithFormat:@"%f",self.tokens[indexPath.row].balance];
    cell.balance.text = [NSString stringWithFormat:@"%f",0.0];
    cell.balanceSymbol.text =
    cell.mainBalanceSymbol.text = self.tokens[indexPath.row].symbol;
    
    if ([self.activeToken isEqual:self.tokens[indexPath.row]]) {
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    return cell;
}

- (IBAction)didPressedBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
