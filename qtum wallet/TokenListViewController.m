//
//  TokenListViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "TokenListViewController.h"
#import "TokenCell.h"
#import "QRCodeManager.h"

NSString *const ShareContractTokensText = @"It's my tokens";

@interface TokenListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@end

@implementation TokenListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[PopUpsManager sharedInstance] showLoaderPopUp];
}


#pragma mark - Coordinator invocation

-(void)reloadTable {
    __weak __typeof(self)wealSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wealSelf.tableView reloadData];
    });
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate didSelectTokenIndexPath:indexPath withItem:self.tokens[indexPath.row]];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.delegate didDeselectTokenIndexPath:indexPath withItem:self.tokens[indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tokens.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TokenCell* cell = [tableView dequeueReusableCellWithIdentifier:tokenCellIdentifire];
    [cell setupWithObject:self.tokens[indexPath.row]];
    return cell;
}

#pragma mark - Actions

- (IBAction)actionShare:(id)sender {
    [self createAndShareQRCode];
}

#pragma mark - Share Tokens

- (void)createAndShareQRCode{
    
    if (self.tokens.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"You haven't tokens for share"];
        return;
    }
    
    [[PopUpsManager sharedInstance] showLoaderPopUp];
    
    NSMutableArray *array = [NSMutableArray new];
    for (Contract *token in self.tokens) {
        
        [array addObject:token.contractAddress];
    }
    
    __weak typeof(self) weakSelf = self;
    [QRCodeManager createQRCodeFromContractsTokensArray:[array copy] forSize:CGSizeMake(500, 500) withCompletionBlock:^(UIImage *image) {
        [[PopUpsManager sharedInstance] dismissLoader];
        if (!image) {
            [SVProgressHUD showErrorWithStatus:@"Error in QRCodeCreation"];
        }else{
            [weakSelf shareQRCode:image];
        }
    }];
}

- (void)shareQRCode:(UIImage *)image{
    NSString *text = ShareContractTokensText;
    UIImage *qrCode = image;
    
    NSArray *sharedItems = @[qrCode, text];
    UIActivityViewController *sharingVC = [[UIActivityViewController alloc] initWithActivityItems:sharedItems applicationActivities:nil];
    
    [self presentViewController:sharingVC animated:YES completion:nil];
}

@end
