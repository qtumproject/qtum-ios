//
//  QTUMAddressTokenTableViewCell.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 19.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QTUMAddressTokenTableViewCell.h"

@interface QTUMAddressTokenTableViewCell ()


@end

@implementation QTUMAddressTokenTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];
}

- (void)setSelected:(BOOL) selected animated:(BOOL) animated {
	[super setSelected:selected animated:animated];

}

- (void)actionPlus:(id) sender {
	[self.delegate actionPlus:sender];
}

@end
