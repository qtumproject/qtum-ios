//
//  WalletNameViewController.h
//  qtum wallet
//
//  Created by Никита Федоренко on 30.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthCoordinator.h"

@interface WalletNameViewController : UIViewController

@property (weak,nonatomic) id <AuthCoordinatorDelegate> delegate;

@end
