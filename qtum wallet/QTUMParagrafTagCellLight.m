//
//  QTUMParagrafTagCellLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 24.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QTUMParagrafTagCellLight.h"

@implementation QTUMParagrafTagCellLight

-(UIFont*)boldFont {
    
    return [UIFont fontWithName:@"ProximaNova-Bold" size:16];
}

-(UIFont*)regularFont {
    return [UIFont fontWithName:@"ProximaNova-Light" size:14];
}

-(UIColor*)linkColor {
    return lightGreenColor();
}

-(UIColor*)textColor {
    return lightDarkGrayColor();
}

@end
