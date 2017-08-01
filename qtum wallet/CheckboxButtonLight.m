//
//  CheckboxButtonLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 31.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "CheckboxButtonLight.h"

@implementation CheckboxButtonLight

-(UIColor*)fillColorForSelectedState {
    return lightGreenColor();
}

-(UIColor*)fillColorForDeselectedState {
    return [UIColor whiteColor];
}

-(UIColor*)borderColorForDeselectedState {
    return lightGreenColor();
}

-(UIColor*)borderColorForSelectedState {
    return lightGreenColor();
}

-(UIColor*)indicatorTintColor {
    return [UIColor whiteColor];
}

@end
