//
//  TokenFunctionDetailViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 22.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbiinterfaceItem.h"
#import "CreateTokenCoordinator.h"
@class Token;

@interface TokenFunctionDetailViewController : UIViewController

@property (weak,nonatomic) id <CreateTokenCoordinatorDelegate> delegate;
@property (strong,nonatomic) AbiinterfaceItem* function;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak,nonatomic) Token* token;

-(void)showResultViewWithOutputs:(NSArray*) outputs;


@end
