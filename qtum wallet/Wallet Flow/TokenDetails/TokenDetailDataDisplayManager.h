//
//  TokenDetailDataDisplayManager.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 24.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TokenDetailDisplayDataManagerDelegate.h"
#import "Contract.h"

@protocol TokenDetailDataDisplayManager <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id <TokenDetailDisplayDataManagerDelegate> delegate;
@property (nonatomic, strong) Contract *token;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIView *emptyPlaceholderView;

- (void)setupFething;
- (void)reloadWithFeching;
- (void)failedConnection;
- (void)reconnect;

@end
