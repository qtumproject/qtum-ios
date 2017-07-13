//
//  CustomAbiInterphaseViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InterfaceInputFormModel.h"

@protocol ContractCoordinatorDelegate;

@interface CustomAbiInterphaseViewController : BaseViewController <ScrollableContentViewController>

@property (weak,nonatomic) id <ContractCoordinatorDelegate> delegate;
@property (strong,nonatomic) InterfaceInputFormModel* formModel;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (assign,nonatomic) UIEdgeInsets originInsets;
@property (copy, nonatomic) NSString* contractTitle;

@end
