//
//  QTUMDefaultTagCell.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 20.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QTUMDefaultTagCell.h"

NSString * const QTUMDefaultTagCellReuseIdentifire = @"QTUMDefaultTagCellReuseIdentifire";

@implementation QTUMDefaultTagCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

-(CGFloat)calculateSelfHeight {
    return 212;
}

@end
