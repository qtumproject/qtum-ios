//
//  ContractsHeaderCell.m
//  qtum wallet
//
//  Created by VladimirLebedevich on 12.12.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ContractsHeaderCell.h"

@interface ContractsHeaderCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishedTextLabel;


@end

@implementation ContractsHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.nameTextLabel.text = NSLocalizedString(@"Name", @"");
    self.publishedTextLabel.text = NSLocalizedString(@"Publish Date", @"");
}


@end
