//
//  NewPaymentOutput.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 04.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NewPaymentOutputDelegate;

@protocol NewPaymentOutput <NSObject>

@property (weak, nonatomic) id <NewPaymentOutputDelegate> delegate;

- (void)setAdress:(NSString*)adress andValue:(NSString*)amount;
- (void)updateControlsWithTokensExist:(BOOL) isExist
                    choosenTokenExist:(BOOL) choosenExist
                      walletBalance:(CGFloat) walletBalance
             andUnconfimrmedBalance:(CGFloat) walletUnconfirmedBalance;
- (void)updateContentWithContract:(Contract*) contract;
- (void)updateContentFromQRCode:(NSDictionary*) qrCodeDict;
- (void)clearFields;
- (void)showErrorPopUp:(NSString *)message;
- (void)showCompletedPopUp;
- (void)showLoaderPopUp;
- (void)hideLoaderPopUp;

@end
