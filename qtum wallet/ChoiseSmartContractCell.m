//
//  ChoiseSmartContractCell.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "ChoiseSmartContractCell.h"

@interface ChoiseSmartContractCell ()

@end

@implementation ChoiseSmartContractCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.disclosure.tintColor = customBlueColor();
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = customRedColor();
    [self setSelectedBackgroundView:bgColorView];
}


@end
