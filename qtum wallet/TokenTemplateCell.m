//
//  TokenTemplateCell.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 23.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "TokenTemplateCell.h"

@interface TokenTemplateCell ()


@end

@implementation TokenTemplateCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.disclousureImage.tintColor = customBlueColor();
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = customRedColor();
    [self setSelectedBackgroundView:bgColorView];
}

@end
