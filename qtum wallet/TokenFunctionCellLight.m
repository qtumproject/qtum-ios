//
//  TokenFunctionCellLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 02.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "TokenFunctionCellLight.h"

@implementation TokenFunctionCellLight

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.disclousere.tintColor = lightBlackColor();
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = lightBlueColor();
    [self setSelectedBackgroundView:bgColorView];
}

-(void)setupWithObject:(AbiinterfaceItem*)object {
    
    self.functionName.text = object.name;
}


@end
