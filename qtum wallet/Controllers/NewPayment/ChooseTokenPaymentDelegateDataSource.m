//
//  ChooseTokenPaymentDelegateDataSource.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 13.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "ChooseTokenPaymentDelegateDataSource.h"
#import "ChoseTokenPaymentCell.h"
#import "ChooseTokekPaymentDelegateDataSourceDelegate.h"
#import "NSNumber+Comparison.h"

@interface ChooseTokenPaymentDelegateDataSource()

@property (nonatomic) BOOL needSelectDefaultCell;

@end

@implementation ChooseTokenPaymentDelegateDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        _needSelectDefaultCell = YES;
    }
    return self;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 46;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        [self.delegate didSelectTokenIndexPath:indexPath withItem:nil];
        return;
    }
    
    Contract* token = self.tokens[indexPath.row - 1];
    
    if ([token isEqual:self.activeToken]) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        self.needSelectDefaultCell = NO;
        self.activeToken = nil;
        [self.delegate didResetToDefaults];
    } else {
        [self.delegate didSelectTokenIndexPath:indexPath withItem:token];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.tokens.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChoseTokenPaymentCell* cell = [tableView dequeueReusableCellWithIdentifier:choseTokenPaymentCellIdentifire];
    
    if (indexPath.row == 0) {
        cell.tokenName.text = NSLocalizedString(@"QTUM (Default)", nil);
        cell.mainBalance.text =
        cell.balance.text =
        cell.balanceSymbol.text =
        cell.mainBalanceSymbol.text = @"";
        
        if (!self.activeToken && self.needSelectDefaultCell) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    } else {
        
        cell.tokenName.text = self.tokens[indexPath.row - 1].localName;
        cell.mainBalance.text = self.tokens[indexPath.row - 1].balanceString;
        cell.balance.text = [NSString stringWithFormat:@"%.3f", 0.0];
        cell.balanceSymbol.text =
        cell.mainBalanceSymbol.text = self.tokens[indexPath.row - 1].symbol;
        cell.shortBalance = self.tokens[indexPath.row - 1].shortBalanceString;
        
        if ([self.activeToken isEqual:self.tokens[indexPath.row - 1]]) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }

    return cell;
}

@end
