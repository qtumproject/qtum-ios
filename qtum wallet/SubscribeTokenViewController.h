//
//  SubscribeTokenViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SubscribeTokenDataSourceDelegate;

@protocol SubscribeTokenCoordinatorDelegate;

@interface SubscribeTokenViewController : UIViewController

@property (weak,nonatomic) id <SubscribeTokenCoordinatorDelegate> delegate;
@property (strong, nonatomic) SubscribeTokenDataSourceDelegate* delegateDataSource;

@end
