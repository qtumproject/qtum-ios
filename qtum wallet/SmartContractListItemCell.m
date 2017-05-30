//
//  SmartContractListItemCell.m
//  qtum wallet
//
//  Created by Никита Федоренко on 30.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "SmartContractListItemCell.h"

@implementation SmartContractListItemCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = customRedColor();
    [self setSelectedBackgroundView:bgColorView];
}

@end
