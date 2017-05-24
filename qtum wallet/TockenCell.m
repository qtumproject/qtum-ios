//
//  TockenCell.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "TockenCell.h"

@interface TockenCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSeparatorHeight;
@end

@implementation TockenCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)updateConstraints{
    [super updateConstraints];
    self.topSeparatorHeight.constant = 0.5f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
