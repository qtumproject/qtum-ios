//
//  TemplatesHeaderCell.m
//  qtum wallet
//
//  Created by VladimirLebedevich on 12.12.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "TemplatesHeaderCell.h"

@interface TemplatesHeaderCell ()

@property (weak, nonatomic) IBOutlet UILabel *typeTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishedDateTextLabel;

@end

@implementation TemplatesHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.typeTextLabel.text = NSLocalizedString(@"Type", @"");
    self.publishedDateTextLabel.text = NSLocalizedString(@"Publish Date", @"");
}

@end
