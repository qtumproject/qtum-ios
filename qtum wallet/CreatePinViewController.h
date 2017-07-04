//
//  CreatePinViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "AuthCoordinator.h"
#import "PinController.h"

@protocol CreatePinViewControllerDelegate <NSObject>

-(void)cancelCreateWallet;
-(void)didEnteredFirstTimePass:(NSString*)pass;

@end

@interface CreatePinViewController : PinController

@property (weak,nonatomic) id <CreatePinViewControllerDelegate> delegate;

@end
