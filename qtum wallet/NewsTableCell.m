//
//  NewsTableCell.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 07.02.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "NewsTableCell.h"

@implementation NewsTableCell

-(void)prepareForReuse {
    self.titleLabel.text = @"";
    self.descriptionLabel.text = @"";
    self.dateLabel.text = @"";
}

#pragma mark - Public Methods

-(void)setContentWithDict:(NewsCellModel*) object {
    self.descriptionLabel.text = object.shortString;
    self.titleLabel.text = object.title;
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"dd MMM"];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[LanguageManager currentLanguageCode]]];
    self.dateLabel.text = [NSString stringWithFormat:@"%@", [formatter stringFromDate:object.date]];
}

@end
