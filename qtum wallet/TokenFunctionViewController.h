//
//  TokenFunctionViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InterfaceInputFormModel.h"
#import "ContractCoordinator.h"
@class Token;

@interface TokenFunctionViewController : UIViewController

@property (strong,nonatomic) InterfaceInputFormModel* formModel;
@property (weak,nonatomic) id <ContractCoordinatorDelegate> delegate;
@property (weak,nonatomic) Contract* token;

@end
