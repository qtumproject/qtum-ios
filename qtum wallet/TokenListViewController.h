//
//  TokenListViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Token.h"
#import "WalletCoordinator.h"

@interface TokenListViewController : UIViewController

@property (strong, nonatomic) NSArray<Token*>* tokens;
@property (weak,nonatomic) id <WalletCoordinatorDelegate> delegate;

-(void)reloadTable;

@end
