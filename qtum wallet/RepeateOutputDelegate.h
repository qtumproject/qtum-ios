//
//  RepeateOutputDelegate.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 10.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RepeateOutputDelegate <NSObject>

- (void)didCreateWalletPressed;

- (void)didCancelPressedOnRepeatePin;

- (void)didEnteredSecondPin:(NSString *) pin;

@end
