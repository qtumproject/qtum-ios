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

-(void)updateContentWithContract:(Contract*) contract;
-(void)updateContentFromQRCode:(NSDictionary*) qrCodeDict;
-(void)showErrorPopUp;
-(void)showCompletedPopUp;
-(void)showLoaderPopUp;

@end
