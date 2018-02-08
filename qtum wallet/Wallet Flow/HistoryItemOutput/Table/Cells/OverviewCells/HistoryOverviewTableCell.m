//
//  HistoryOverviewTableCell.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 07.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "HistoryOverviewTableCell.h"

@interface HistoryOverviewTableCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelHeight;

@end

@implementation HistoryOverviewTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)actionCopy:(id)sender {
    
    [self.delegate didPressedCopyWithValue:self.valueTextLabel.text];
}

-(void)sizeToFitLabels {
    
    [self.valueTextLabel sizeToFit];
    CGFloat height = self.valueTextLabel.frame.size.height;
    self.valueLabelHeight.constant = height;
    
    [self.titleTextLabel sizeToFit];
    height = self.titleTextLabel.frame.size.height;
    self.titleLabelHeight.constant = height;
}


@end
