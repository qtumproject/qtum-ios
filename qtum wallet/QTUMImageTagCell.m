//
//  QTUMImageTagCell.m
//  qtum wallet
//
//  Created by Никита Федоренко on 20.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QTUMImageTagCell.h"

NSString * const QTUMImageTagCellReuseIdentifire = @"QTUMImageTagCellReuseIdentifire";

@interface QTUMImageTagCell ()


@end

@implementation QTUMImageTagCell

-(void)prepareForReuse {
    
    [super prepareForReuse];
    self.tagImageView.contentMode = UIViewContentModeCenter;
    self.tagImageView.image = [UIImage imageNamed:@"news-placehodler"];
}


@end
