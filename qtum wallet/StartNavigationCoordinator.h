//
//  StartNavigationCoordinator.h
//  qtum wallet
//
//  Created by Никита Федоренко on 27.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PinViewController.h"


@interface StartNavigationCoordinator : UINavigationController <PinCoordinator>

@property (nonatomic, copy) void(^createPinCompletesion)();
@property (strong,nonatomic,readonly) NSString* walletName;
@property (strong,nonatomic,readonly) NSString* walletPin;
@property (strong,nonatomic,readonly) NSArray* walletBrainKey;

-(void)addWalletName:(NSString*)name;
-(void)addPin:(NSString*)pin;
-(void)addBrainKey:(NSArray*)key;

-(void)clear;

@end
