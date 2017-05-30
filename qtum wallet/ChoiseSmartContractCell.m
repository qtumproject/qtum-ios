//
//  ChoiseSmartContractCell.m
//  qtum wallet
//
//  Created by Никита Федоренко on 30.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
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
