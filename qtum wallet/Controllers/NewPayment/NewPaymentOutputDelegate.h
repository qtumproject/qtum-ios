//
//  NewPaymentOutputDelegate.h
//  qtum wallet
//
//  Created by Никита Федоренко on 04.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NewPaymentOutputDelegate <NSObject>

- (void)showQRCodeScaner;
- (void)showChooseToken;
- (void)didPressedSendActionWithAddress:(NSString*) address andAmount:(NSNumber*) amount;

@end
