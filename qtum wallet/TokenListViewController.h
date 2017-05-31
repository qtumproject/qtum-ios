//
//  TokenListViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Token.h"
#import "WalletCoordinator.h"

@protocol TokenListViewControllerDelegate <NSObject>

@required
- (void)didSelectTokenIndexPath:(NSIndexPath *)indexPath withItem:(Token*) item;
- (void)didDeselectTokenIndexPath:(NSIndexPath *)indexPath withItem:(Token*) item;

@end

@interface TokenListViewController : UIViewController

@property (strong, nonatomic) NSArray<Token*>* tokens;
@property (weak,nonatomic) id <TokenListViewControllerDelegate> delegate;

-(void)reloadTable;

@end
