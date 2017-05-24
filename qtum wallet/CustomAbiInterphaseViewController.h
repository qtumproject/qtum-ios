//
//  CustomAbiInterphaseViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InterfaceInputFormModel.h"

@protocol CreateTokenCoordinatorDelegate;

@interface CustomAbiInterphaseViewController : BaseViewController <ScrollableContentViewController>

@property (weak,nonatomic) id <CreateTokenCoordinatorDelegate> delegate;
@property (strong,nonatomic) InterfaceInputFormModel* formModel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
