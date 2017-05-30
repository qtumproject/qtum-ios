//
//  ChooseSmartContractViewController.h
//  qtum wallet
//
//  Created by Никита Федоренко on 30.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateTokenCoordinator.h"

@interface ChooseSmartContractViewController : UIViewController

@property (weak,nonatomic) id <CreateTokenCoordinatorDelegate> delegate;

@end
