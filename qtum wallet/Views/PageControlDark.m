//
//  PageControlDark.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 06.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "PageControlDark.h"
#import "PageControlItemDark.h"

@implementation PageControlDark

- (UIView<PageControlItem> *)createViewItem {
    return [PageControlItemDark new];
}

- (CGFloat)spaceBetweenItems {
    return 4.0f;
}

@end
