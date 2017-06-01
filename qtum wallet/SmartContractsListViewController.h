//
//  SmartContractsListViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContractCoordinator.h"

@interface SmartContractsListViewController : UIViewController

@property (strong, nonatomic) NSArray <Contract*>* contracts;
@property (weak,nonatomic) id <ContractCoordinatorDelegate> delegate;

@end
