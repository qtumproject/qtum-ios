//
//  TokenTemplateCell.m
//  qtum wallet
//
//  Created by Никита Федоренко on 23.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "TokenTemplateCell.h"

@interface TokenTemplateCell ()

@property (weak, nonatomic) IBOutlet UIImageView *disclousureImage;

@end

@implementation TokenTemplateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.disclousureImage.tintColor = customBlueColor();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
