//
//  Utils.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 03.11.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString const *PUBLIC_ADDRESS_STRING_KEY;
extern NSString const *PRIVATE_ADDRESS_STRING_KEY;
extern NSString const *AMOUNT_STRING_KEY;
extern NSString const *kIsToken;


UIColor *customBlueColor();
UIColor *textFieldLineColorSelected();
UIColor *textFieldLineColorDeselected();
UIColor *customRedColor();
UIColor *historyGreenColor();
UIColor *historyGrayColor();
UIColor *customBlackColor();


typedef NS_ENUM(NSInteger,PinType){
    EnterType,
    CreateType,
    ConfirmType,
    NewType,
    OldType
};

@protocol PinCoordinator <NSObject>

@required
-(void)confirmPin:(NSString*)pin andCompletision:(void(^)(BOOL success)) completisiom;
@optional
-(void)confilmPinFailed;
-(void)setAnimationState:(BOOL)isAnimating;

@end
