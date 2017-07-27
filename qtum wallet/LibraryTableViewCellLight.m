//
//  LibraryTableViewCellLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 27.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "LibraryTableViewCellLight.h"

@implementation LibraryTableViewCellLight

- (void)awakeFromNib {
    [super awakeFromNib];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = lightBlueColor();
    [self setSelectedBackgroundView:bgColorView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    self.checkImageView.hidden = !selected;
    [super setSelected:selected animated:animated];    
}

@end
