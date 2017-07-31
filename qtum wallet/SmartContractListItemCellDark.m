//
//  SmartContractListItemCellDark.m
//  qtum wallet
//
//  Created by Никита Федоренко on 28.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "SmartContractListItemCellDark.h"

@implementation SmartContractListItemCellDark

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = customRedColor();
    [self setSelectedBackgroundView:bgColorView];
}

@end
