//
//  CreateTokenStep1ViewController.h
//  qtum wallet
//
//  Created by Никита Федоренко on 03.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateTokenCoordinatorDelegate;

@interface CreateTokenStep1ViewController : UIViewController

@property (weak,nonatomic) id <CreateTokenCoordinatorDelegate> delegate;

@end
