//
//  ConfirmBorderedViewDark.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.01.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "ConfirmBorderedViewDark.h"

@implementation ConfirmBorderedViewDark

- (void)configBorder {
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = YES;
    self.backgroundColor = customBlackColor();
    self.layer.borderColor = customBlueColor().CGColor;
}

- (void)setFailedState:(BOOL) isFailed {
    
    if (isFailed) {
        self.layer.borderColor = customRedColor().CGColor;
    } else {
        self.layer.borderColor = customBlueColor().CGColor;
    }
}

@end
