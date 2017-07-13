//
//  TokenCellDark.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 07.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "TokenCellDark.h"

@implementation TokenCellDark

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = customRedColor();
    [self setSelectedBackgroundView:bgColorView];
}

- (void)changeHighlight:(BOOL)value {
    
    self.tokenName.textColor =
    self.mainSymbol.textColor =
    self.symbol.textColor =
    self.mainValue.textColor =
    self.value.textColor = value ? customBlackColor() : customBlueColor();
    
    self.symbol.alpha =
    self.value.alpha = value ? 1.0f : 0.4f;
}

@end
