//
//  RepeateViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.02.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "PinController.h"
#import "AuthCoordinator.h"

@protocol RepeateViewControllerDelegate <NSObject>

-(void)didCreateWallet;
-(void)cancelCreateWallet;
-(void)didEnteredSecondTimePass:(NSString*)pass;

@end

@interface RepeateViewController : PinController

@property (weak,nonatomic) id <RepeateViewControllerDelegate> delegate;

-(void)startCreateWallet;
-(void)endCreateWalletWithError:(NSError*)error;

@end
