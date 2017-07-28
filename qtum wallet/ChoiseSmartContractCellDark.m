//
//  ChoiseSmartContractCellDark.m
//  qtum wallet
//
//  Created by Никита Федоренко on 28.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "ChoiseSmartContractCellDark.h"

@implementation ChoiseSmartContractCellDark

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.disclosure.tintColor = customBlueColor();
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = customRedColor();
    [self setSelectedBackgroundView:bgColorView];
}


@end
