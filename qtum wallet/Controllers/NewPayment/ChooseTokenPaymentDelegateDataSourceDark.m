//
//  ChooseTokenPaymentDelegateDataSourceDark.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 10.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "ChooseTokenPaymentDelegateDataSourceDark.h"
#import "ChoseTokenPaymentCellDark.h"
#import "ChooseTokekPaymentDelegateDataSourceDelegate.h"

@interface ChooseTokenPaymentDelegateDataSourceDark ()

@end

@implementation ChooseTokenPaymentDelegateDataSourceDark

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 46;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Contract* token = self.tokens[indexPath.row];
    
    if ([token isEqual:self.activeToken]) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.activeToken = nil;
        [self.delegate didResetToDefaults];
    } else {
        [self.delegate didSelectTokenIndexPath:indexPath withItem:token];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(didDeselectTokenIndexPath:withItem:)]) {
        [self.delegate didDeselectTokenIndexPath:indexPath withItem:self.tokens[indexPath.row]];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.tokens.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChoseTokenPaymentCellDark* cell = [tableView dequeueReusableCellWithIdentifier:choseTokenPaymentCellIdentifire];
    cell.tokenName.text = self.tokens[indexPath.row].localName;
    cell.mainBalance.text = [NSString stringWithFormat:@"%f",self.tokens[indexPath.row].balance];
    cell.balance.text = [NSString stringWithFormat:@"%f",0.0];
    cell.balanceSymbol.text =
    cell.mainBalanceSymbol.text = self.tokens[indexPath.row].symbol;
    
    if ([self.activeToken isEqual:self.tokens[indexPath.row]]) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    return cell;
}

@end
