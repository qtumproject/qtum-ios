//
//  QStoreContractViewController.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 28.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContractCoordinator.h"

@interface QStoreContractViewController : UIViewController

@property (nonatomic, weak) id<ContractCoordinatorDelegate> delegate;

@end
