//
//  FirstAuthViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.02.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthCoordinator.h"

@protocol FirstAuthViewControllerDelegate <NSObject>

-(void)didLoginPressed;
-(void)restoreButtonPressed;
-(void)createNewButtonPressed;

@end

@interface FirstAuthViewController : BaseViewController

@property (weak,nonatomic)id <FirstAuthViewControllerDelegate> delegate;

@end
