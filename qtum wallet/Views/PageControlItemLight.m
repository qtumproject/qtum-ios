//
//  PageControlItemLight.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 06.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "PageControlItemLight.h"

@implementation PageControlItemLight

- (void)setSelectedState:(BOOL)selected {
    self.backgroundColor = lightBlackColor();
    self.alpha = selected ? 0.6f : 0.3f;
    self.layer.cornerRadius = selected ? 4.0f : 3.0f;
    self.layer.masksToBounds = YES;
}

- (CGFloat)getNotSelectedWidth {
    return 6;
}

- (CGFloat)getSelectedWidth {
    return 8;
}

@end
