//
//  ConfirmWordCollectionViewCellDark.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 04.01.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "ConfirmWordCollectionViewCellDark.h"

@implementation ConfirmWordCollectionViewCellDark

- (void)configTextLabel {
    
    self.backView.layer.borderWidth = 1;
    self.backView.layer.borderColor = customBlueColor().CGColor;
}

@end
