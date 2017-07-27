//
//  TokenCellSubscribeDark.m
//  qtum wallet
//
//  Created by Никита Федоренко on 27.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "TokenCellSubscribeDark.h"

@implementation TokenCellSubscribeDark

- (void)awakeFromNib {
    [super awakeFromNib];
    self.indicator.tintColor = customBlueColor();
}

@end
