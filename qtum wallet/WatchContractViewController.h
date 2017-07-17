//
//  WatchContractViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 09.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContractCoordinator.h"

@interface WatchContractViewController : BaseViewController <ScrollableContentViewController>

@property (weak,nonatomic) id <ContractCoordinatorDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (assign,nonatomic) UIEdgeInsets originInsets;

- (void)changeStateForSelectedTemplate:(TemplateModel *)templateModel;

@end
