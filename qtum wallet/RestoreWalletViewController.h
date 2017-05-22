//
//  RestoreWalletViewController.h
//  qtum wallet
//
//  Created by Никита Федоренко on 21.02.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthCoordinator.h"

@interface RestoreWalletViewController : UIViewController

@property (weak,nonatomic) id <AuthCoordinatorDelegate> delegate;

-(void)restoreSucces;
-(void)restoreFailed;

@end
