//
//  HistoryHeaderVIew.m
//  qtum wallet
//
//  Created by Никита Федоренко on 03.04.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "HistoryHeaderVIew.h"

@interface HistoryHeaderVIew ()

@property (assign,nonatomic)BOOL isActivityFadeout;

@end

@implementation HistoryHeaderVIew

- (void)fadeInActivity{
    if (_isActivityFadeout) {
        self.isActivityFadeout = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 1;
        }];
    }
}

- (void)fadeOutActivity{
    if (!_isActivityFadeout) {
        self.isActivityFadeout = YES;
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0;
        }];
    }
}

@end
