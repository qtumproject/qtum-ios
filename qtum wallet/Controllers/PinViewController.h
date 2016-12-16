//
//  PinViewController.h
//  qtum wallet
//
//  Created by Никита Федоренко on 13.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreatePinRootController.h"

typedef NS_ENUM(NSInteger,PinType){
    EnterType,
    CreateType,
    ConfirmType,
    NewType,
    OldType
};

@protocol PinCoordinator;

@interface PinViewController : BaseViewController

@property (weak,nonatomic) id <PinCoordinator> delegate;
@property (assign,nonatomic) PinType type;

@end

@protocol PinCoordinator <NSObject>

@required
-(void)confirmPin:(NSString*)pin andCompletision:(void(^)(BOOL success)) completisiom;
@optional
-(void)confilmPinFailed;
-(void)setAnimationState:(BOOL)isAnimating;

@end
