//
//  TokenFunctionDetailViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 22.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbiinterfaceItem.h"
#import "WalletCoordinator.h"
@class Contract;

@interface TokenFunctionDetailViewController : UIViewController

@property (weak,nonatomic) id <WalletCoordinatorDelegate> delegate;
@property (strong,nonatomic) AbiinterfaceItem* function;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak,nonatomic) Contract* token;

-(void)showResultViewWithOutputs:(NSArray*) outputs;


@end
