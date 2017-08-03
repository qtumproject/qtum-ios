//
//  AddressControllCellLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 02.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "AddressControllCellLight.h"

@implementation AddressControllCellLight

- (void)awakeFromNib {
    
    [super awakeFromNib];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = lightBlueColor();
    [self setSelectedBackgroundView:bgColorView];
}


@end
