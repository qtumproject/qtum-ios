//
//  PopUpContent.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 03.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "PopUpContent.h"

@implementation PopUpContent

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message okTitle:(NSString *)okTitle cancelTitle:(NSString *)cancelTitle{
    
    self = [super init];
    if (self) {
        self.titleString = title;
        self.messageString = message;
        self.okButtonTitle = okTitle;
        self.cancelButtonTitle = cancelTitle;
    }
    return self;
}

- (BOOL)isEqual:(PopUpContent *)object{
    return [self.titleString isEqualToString:object.titleString] && [self.messageString isEqualToString:object.messageString] && [self.okButtonTitle isEqualToString:object.okButtonTitle] && [self.cancelButtonTitle isEqualToString:object.cancelButtonTitle];
}

@end
