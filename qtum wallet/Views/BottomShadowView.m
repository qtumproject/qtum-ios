//
//  BottomShadowView.m
//  qtum wallet
//
//  Created by Никита Федоренко on 22.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "BottomShadowView.h"

@implementation BottomShadowView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.06].CGColor;
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 1;
    self.layer.shadowOffset = CGSizeMake(0, 3);
}

@end
