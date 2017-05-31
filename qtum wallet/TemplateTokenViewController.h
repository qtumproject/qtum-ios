//
//  TemplateTokenViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 23.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateTokenCoordinator.h"
#import "TemplateModel.h"

@interface TemplateTokenViewController : UIViewController

@property (strong, nonatomic) NSArray <TemplateModel*>* templateModels;
@property (weak,nonatomic) id <CreateTokenCoordinatorDelegate> delegate;

@end
