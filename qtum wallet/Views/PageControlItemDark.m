//
//  PageControlItemDark.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 06.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "PageControlItemDark.h"

@interface PageControlItemDark()

@property(nonatomic, strong) UIImage* activeImage;
@property(nonatomic, strong) UIImage* inactiveImage;

@end

@implementation PageControlItemDark

- (instancetype)init {
    self = [super init];
    if (self) {
        _activeImage= [UIImage imageNamed:@"activePageControl"];
        _inactiveImage = [UIImage imageNamed:@"deactivePageControl"];
        self.tintColor = customBlackColor();
    }
    return self;
}

- (void)setSelectedState:(BOOL)selected {
    self.image = selected ? self.activeImage : self.inactiveImage;
}

- (CGFloat)getNotSelectedWidth {
    return 6;
}

- (CGFloat)getSelectedWidth {
    return 9;
}

@end
