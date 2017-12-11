//
//  RestoreWalletViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.02.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthCoordinator.h"
#import "RestoreWalletOutput.h"
#import "Presentable.h"

@interface RestoreWalletViewController : BaseViewController <RestoreWalletOutput, Presentable>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomForButtonsConstraint;

@end
