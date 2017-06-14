//
//  BackupContractsViewController.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 13.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContractCoordinator.h"

@interface BackupContractsViewController : UIViewController

@property (weak,nonatomic) id <ContractCoordinatorDelegate> delegate;

@end
