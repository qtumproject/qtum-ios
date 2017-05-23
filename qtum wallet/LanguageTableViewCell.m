//
//  LanguageTableViewCell.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 23.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
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
        [self.titleLabel setTextColor:[UIColor colorWithRed:35/255.0f green:35/255.0f blue:40/255.0f alpha:1.0f]];
    }else{
        self.selectedView.hidden = YES;
        [self.titleLabel setTextColor:[UIColor colorWithRed:46/255.0f green:154/255.0f blue:208/255.0f alpha:1.0f]];
    }
}

@end
