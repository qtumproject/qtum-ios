//
//  TokenFunctionCellDark.m
//  qtum wallet
//
//  Created by Никита Федоренко on 02.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "TokenFunctionCellDark.h"

@implementation TokenFunctionCellDark

- (void)awakeFromNib {
    [super awakeFromNib];
    self.disclousere.tintColor = customBlueColor();
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = customRedColor();
    [self setSelectedBackgroundView:bgColorView];
}

-(void)setupWithObject:(AbiinterfaceItem*)object {
    
    self.functionName.text = object.name;
    
}


@end
