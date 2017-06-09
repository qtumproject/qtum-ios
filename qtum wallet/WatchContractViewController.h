//
//  WatchContractViewController.h
//  qtum wallet
//
//  Created by Никита Федоренко on 09.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContractCoordinator.h"

@interface WatchContractViewController : UIViewController

@property (weak,nonatomic) id <ContractCoordinatorDelegate> delegate;

@end
