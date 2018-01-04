//
//  ConfirmWordCollectionViewCell.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.01.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "ConfirmWordCollectionViewCell.h"

@interface ConfirmWordCollectionViewCell ()

@end

NSString* confirmWordCollectionViewCellIdentifire = @"confirmWordCollectionViewCellIdentifire";

@implementation ConfirmWordCollectionViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self configTextLabel];
}

- (void)configTextLabel {
    
    self.backView.layer.borderWidth = 1;
    self.backView.layer.borderColor = lightGreenColor().CGColor;
    self.backView.layer.cornerRadius = 5;
    self.backView.layer.masksToBounds = YES;
    self.backView.clipsToBounds = YES;
}


@end
