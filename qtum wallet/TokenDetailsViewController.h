//
//  TokenDetailsViewController.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 19.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TokenDetailsTableSource;
@protocol WalletCoordinatorDelegate;

@interface TokenDetailsViewController : UIViewController

@property (nonatomic, weak) id<WalletCoordinatorDelegate> delegate;

- (void)setTableSource:(TokenDetailsTableSource *)source;

@end
