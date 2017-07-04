//
//  NewPaymentViewController.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.11.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewPaymentViewControllerDelegate <NSObject>

- (void)showQRCodeScaner;
- (void)showChooseToken;
- (void)didPressedSendActionWithAddress:(NSString*) address andAmount:(NSNumber*) amount;

@end

@interface NewPaymentViewController : BaseViewController

@property (weak, nonatomic) id <NewPaymentViewControllerDelegate> delegate;

@property (nonatomic, copy) NSString *currentBalance;
@property (nonatomic, copy) NSDictionary *dictionary;

-(void)setAdress:(NSString*)adress andValue:(NSString*)amount;
-(void)updateContentWithContract:(Contract*) contract;
-(void)updateContentFromQRCode:(NSDictionary*) qrCodeDict;
-(void)showErrorPopUp;
-(void)showCompletedPopUp;
-(void)showLoaderPopUp;

@end
