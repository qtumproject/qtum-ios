//
//  WalletTypeCellWithCollection.m
//  qtum wallet
//
//  Created by Никита Федоренко on 03.04.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "WalletHeaderCell.h"

@implementation WalletHeaderCell

- (IBAction)showAddress:(id)sender {
    [self.delegate showAddressInfo];
}

@end
