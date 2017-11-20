//
//  TokenTemplateCellLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 28.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "TokenTemplateCellLight.h"

@implementation TokenTemplateCellLight

- (void)awakeFromNib {
    
    [super awakeFromNib];
        
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = lightBlueColor();
    [self setSelectedBackgroundView:bgColorView];
}

@end
