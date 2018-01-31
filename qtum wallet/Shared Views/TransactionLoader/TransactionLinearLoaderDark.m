//
//  TransactionLinearLoaderDark.m
//  qtum wallet
//
//  Created by Fedorenko Nikita on 31.01.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "TransactionLinearLoaderDark.h"

@implementation TransactionLinearLoaderDark

-(UIColor*)backColor {
    return customBlackColor();
}

-(UIColor*)loaderColor {
    return [customBlueColor() colorWithAlphaComponent:0.5];
}

@end
