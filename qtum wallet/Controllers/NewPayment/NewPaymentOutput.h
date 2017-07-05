//
//  NewPaymentOutput.h
//  qtum wallet
//
//  Created by Никита Федоренко on 04.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NewPaymentOutputDelegate;

@protocol NewPaymentOutput <NSObject>

@property (weak, nonatomic) id <NewPaymentOutputDelegate> delegate;

- (void)updateControlsWithTokenExist:(BOOL) isExist
                      walletBalance:(CGFloat) walletBalance
             andUnconfimrmedBalance:(CGFloat) walletUnconfirmedBalance;
- (void)updateContentWithContract:(Contract*) contract;
- (void)updateContentFromQRCode:(NSDictionary*) qrCodeDict;
- (void)clearFields;
- (void)showErrorPopUp;
- (void)showCompletedPopUp;
- (void)showLoaderPopUp;
- (void)hideLoaderPopUp;

@end
