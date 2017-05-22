//
//  CustomTextField.m
//  qtum wallet
//
//  Created by Никита Федоренко on 14.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

- (void)deleteBackward {
    BOOL shouldDismiss = [self.text length] == 0;
    
    [super deleteBackward];
    
    if (shouldDismiss) {
        if ([self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
            [self.delegate textField:self shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@""];
        }
    }
}



@end
