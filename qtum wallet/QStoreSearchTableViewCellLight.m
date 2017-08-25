//
//  QStoreSearchTableViewCellLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreSearchTableViewCellLight.h"

@implementation QStoreSearchTableViewCellLight

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = lightBlueColor();
    [self setSelectedBackgroundView:bgColorView];
}


@end
