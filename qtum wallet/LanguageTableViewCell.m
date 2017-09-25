//
//  LanguageTableViewCell.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 23.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "LanguageTableViewCell.h"

@interface LanguageTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *selectedView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation LanguageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setData:(NSString *)titleText selected:(BOOL)selected{
    [self.titleLabel setText:titleText];
    [self changeCellStyle:selected];
}

- (void)changeCellStyle:(BOOL)selected{
    if (selected) {
        self.selectedView.hidden = NO;
        [self.titleLabel setTextColor:[self getSelectedColor]];
    }else{
        self.selectedView.hidden = YES;
        [self.titleLabel setTextColor:[self getDeselectedColor]];
    }
}

- (UIColor *)getSelectedColor {
    return [UIColor whiteColor];
}

- (UIColor *)getDeselectedColor {
    return [UIColor whiteColor];
}

@end
