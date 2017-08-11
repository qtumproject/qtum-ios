//
//  PopUpContentGenerator.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 03.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PopUpContent;

@interface PopUpContentGenerator : NSObject

+ (PopUpContent *)contentForOupsPopUp;
+ (PopUpContent *)contentForUpdateBalance;
+ (PopUpContent *)contentForPhotoLibrary;
+ (PopUpContent *)contentForCreateContract;
+ (PopUpContent *)contentForSend;
+ (PopUpContent *)contentForCompletedBackupFile;
+ (PopUpContent *)contentForBrainCodeCopied;
+ (PopUpContent *)contentForAddressCopied;
+ (PopUpContent *)contentForSourceCode;
+ (PopUpContent *)contentForAbiCopied;
+ (PopUpContent *)contentForRequestTokenPopUp;
+ (PopUpContent *)contentForInvalidQRCodeFormatPopUp;
+ (PopUpContent *)contentForTokenAdded;
+ (PopUpContent *)contentForContractAdded;
+ (PopUpContent *)contentForContractBought;

@end
