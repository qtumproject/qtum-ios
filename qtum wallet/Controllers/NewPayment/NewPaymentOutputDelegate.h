//
//  NewPaymentOutputDelegate.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 04.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NewPaymentOutputDelegate <NSObject>

- (void)didPresseQRCodeScaner;
- (void)didPresseChooseToken;
- (void)didPresseSendActionWithAddress:(NSString*) address
                             andAmount:(NSNumber*) amount
                                andFee:(NSNumber*) fee;
- (void)didViewLoad;

@end
