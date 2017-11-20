//
//  WatchContractViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 09.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContractCoordinator.h"
#import "WatchContractOutputDelegate.h"
#import "WatchContractOutput.h"
#import "Presentable.h"

@protocol FavouriteTemplatesCollectionSourceOutput;

@interface WatchContractViewController : BaseViewController <ScrollableContentViewController, PopUpWithTwoButtonsViewControllerDelegate, WatchContractOutput, Presentable>

@property (assign, nonatomic) UIEdgeInsets originInsets;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (void)okButtonPressed:(PopUpViewController *) sender;

- (void)cancelButtonPressed:(PopUpViewController *) sender;

@end
