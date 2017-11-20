//
//  QStoreListTableViewCellLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 18.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QStoreListTableViewCellLight.h"

@implementation QStoreListTableViewCellLight

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = lightBlueColor();
    [self setSelectedBackgroundView:bgColorView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

- (void)changeHighlight:(BOOL)value {

}

@end
