//
//  TokenFunctionViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InterfaceInputFormModel.h"
#import "WalletCoordinator.h"
@class Token;

@interface TokenFunctionViewController : UIViewController

@property (strong,nonatomic) InterfaceInputFormModel* formModel;
@property (weak,nonatomic) id <WalletCoordinatorDelegate> delegate;
@property (weak,nonatomic) Token* token;

@end
