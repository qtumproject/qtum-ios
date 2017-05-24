//
//  TemplateTokenViewController.h
//  qtum wallet
//
//  Created by Никита Федоренко on 23.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateTokenCoordinator.h"

@interface TemplateTokenViewController : UIViewController

@property (strong, nonatomic) NSArray <NSString*>* templateNames;
@property (weak,nonatomic) id <CreateTokenCoordinatorDelegate> delegate;

@end
