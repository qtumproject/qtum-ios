//
//  SubscribeTokenDataSourceDelegate.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Spendable.h"

@protocol SubscribeTokenDataSourceDelegateDelegate <NSObject>

- (void)tableView:(UITableView *)tableView didSelectContract:(Contract *) contract;

@end

@interface SubscribeTokenDataSourceDelegate : NSObject <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSArray <Contract*>* tokensArray;
@property (weak, nonatomic) id <SubscribeTokenDataSourceDelegateDelegate> delegate;

@end
