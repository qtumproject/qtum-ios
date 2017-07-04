//
//  WalletNameViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthCoordinator.h"

@protocol WalletNameViewControllerDelegate <NSObject>

-(void)cancelCreateWallet;
-(void)didCreatedWalletName:(NSString*)name;

@end

@interface WalletNameViewController : BaseViewController

@property (weak,nonatomic) id <WalletNameViewControllerDelegate> delegate;

@end
