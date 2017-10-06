//
//  FirstNewTableCell.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 09.02.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "FirstNewTableCell.h"

@implementation FirstNewTableCell

-(void)prepareForReuse {
    
    [super prepareForReuse];
    self.customImage.image = [UIImage imageNamed:@"no-image"];
    self.dateLabel.text = @"";
    self.shortDiscriptionLabel.text = @"";
    self.longDiscriptionLabel.text = @"";
}

#pragma mark - Public Methods

-(void)setContentWithDict:(NewsCellModel*) object {
    __weak __typeof(self)weakSelf = self;
    NSString* url = object.imageUrl;
    self.customImage.associatedObject = url;
    [[ImageLoader sharedInstance] getImageWithUrl:url withResultHandler:^(UIImage *image) {
        if ([weakSelf.customImage.associatedObject isEqualToString:url] && image) {
            weakSelf.customImage.image = image;
        }
    }];
    self.shortDiscriptionLabel.text = object.title;
    self.dateLabel.text = [NSString stringWithFormat:@"%@", object.date];
    self.longDiscriptionLabel.text = object.shortString;
}


@end
