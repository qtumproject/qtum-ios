//
//  RepeateViewController.h
//  qtum wallet
//
//  Created by Никита Федоренко on 21.02.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "PinController.h"
#import "AuthCoordinator.h"

@interface RepeateViewController : PinController

@property (weak,nonatomic) id <AuthCoordinatorDelegate> delegate;

-(void)startCreateWallet;
-(void)endCreateWalletWithError:(NSError*)error;

@end
