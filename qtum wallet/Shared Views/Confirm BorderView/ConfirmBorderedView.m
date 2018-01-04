//
//  ConfirmBorderedView.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.01.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "ConfirmBorderedView.h"

@implementation ConfirmBorderedView

-(void)awakeFromNib {
    
    [super awakeFromNib];
    [self configBorder];
}

- (void)configBorder {}

- (void)setFailedState:(BOOL) isFailed {}

@end
