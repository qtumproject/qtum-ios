//
//  TokenFunctionCell.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "TokenFunctionCell.h"

@implementation TokenFunctionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.disclousere.tintColor = customBlueColor();
}

-(void)setupWithObject:(AbiinterfaceItem*)object {
    
    self.functionName.text = object.name;
}

@end
