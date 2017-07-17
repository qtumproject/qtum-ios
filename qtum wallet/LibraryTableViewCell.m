//
//  LibraryTableViewCell.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 17.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "LibraryTableViewCell.h"

@implementation LibraryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = customRedColor();
    [self setSelectedBackgroundView:bgColorView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    self.nameLabel.textColor = selected ? customBlackColor() : customBlueColor();
}

@end
