//
//  TokenFunctionDetailViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 22.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbiinterfaceItem.h"
#import "ContractCoordinator.h"
@class Contract;

@interface TokenFunctionDetailViewController : BaseViewController <ScrollableContentViewController>

@property (weak,nonatomic) id <ContractCoordinatorDelegate> delegate;
@property (strong,nonatomic) AbiinterfaceItem* function;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak,nonatomic) Contract* token;
@property (assign,nonatomic) UIEdgeInsets originInsets;

-(void)showResultViewWithOutputs:(NSArray*) outputs;


@end
