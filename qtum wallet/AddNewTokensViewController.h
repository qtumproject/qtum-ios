//
//  AddNewTokensViewController.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SubscribeTokenCoordinatorDelegate;

@interface AddNewTokensViewController : BaseViewController

@property (weak,nonatomic) id<SubscribeTokenCoordinatorDelegate> delegate;

@end
