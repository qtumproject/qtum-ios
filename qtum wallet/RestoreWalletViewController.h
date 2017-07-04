//
//  RestoreWalletViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.02.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthCoordinator.h"

@protocol RestoreWalletViewControllerDelegate <NSObject>

-(void)didRestorePressedWithWords:(NSArray*)words;
-(void)didRestoreWallet;
-(void)restoreWalletCancelDidPressed;

@end

@interface RestoreWalletViewController : BaseViewController

@property (weak,nonatomic) id <RestoreWalletViewControllerDelegate> delegate;

-(void)restoreSucces;
-(void)restoreFailed;

@end
