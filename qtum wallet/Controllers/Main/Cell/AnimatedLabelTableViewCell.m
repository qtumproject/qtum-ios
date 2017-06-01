//
//  AnimatedLabelTableViewCell.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 30.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "AnimatedLabelTableViewCell.h"

@implementation AnimatedLabelTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)changePositionForLabel:(UILabel *)label andPercent:(CGFloat)percent values:(NSArray *)values constraints:(NSArray*)constraints isLeft:(BOOL)isLeft{
    
    CGFloat minTop = [values[0] floatValue];
    CGFloat maxTop = [values[1] floatValue];
    CGFloat minFont = [values[2] floatValue];
    CGFloat maxFont = [values[3] floatValue];
    
    NSLayoutConstraint *topContsraint = constraints[0];
    NSLayoutConstraint *centerContsraint = constraints[1];
    
    CGFloat newFont = maxFont - (maxFont - minFont) * percent;
    if (newFont < minFont) newFont = minFont;
    if (newFont > maxFont) newFont = maxFont;
    label.font = [label.font fontWithSize:newFont];
    
    CGFloat newTop = percent * (maxTop - minTop) + minTop;
    if (newTop < minTop) newTop = minTop;
    if (newTop > maxTop) newTop = maxTop;
    topContsraint.constant = newTop;
    
    CGFloat offset = 15.0f;
    CGFloat minCenter = 0.0f;
    CGFloat maxCenter = (self.contentView.frame.size.width - label.frame.size.width) / 2.0f - offset;
    CGFloat newCenter = minCenter + (maxCenter - minCenter) * percent * 3;
    if (newCenter < minCenter) newCenter = minCenter;
    if (newCenter > maxCenter) newCenter = maxCenter;
    centerContsraint.constant = newCenter * (isLeft ? -1 : 1);
    
    [self changeAplha:label andPercent:percent values:values];
}

- (void)changeAplha:(UILabel *)label andPercent:(CGFloat)percent values:(NSArray *)values{
    CGFloat firstAlpha = [values[4] floatValue];
    CGFloat lastAlpha = [values[5] floatValue];
    CGFloat centerAlpha = 0.5f;
    
    
    CGFloat alpha;
    CGFloat newPercent;
    if (percent <= 0.5f) {
        newPercent = percent / 0.5f;
        alpha = firstAlpha - (firstAlpha - centerAlpha) * newPercent;
    }else{
        newPercent = (percent - 0.5f) / 0.5f;
        alpha = centerAlpha + (lastAlpha - centerAlpha) * newPercent;
    }
    
    label.alpha = alpha;
}

@end
