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

+ (PopUpContent *)getContentForOupsPopUp;
+ (PopUpContent *)getContentForUpdateBalance;
+ (PopUpContent *)getContentForPhotoLibrary;
+ (PopUpContent *)getContentForCreateContract;
+ (PopUpContent *)getContentForSend;

@end
