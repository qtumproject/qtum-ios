//
//  HistoryItemDelegateDataSource.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 06.04.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HistoryElement;

@interface HistoryItemDelegateDataSource : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) id<HistoryElementProtocol> item;

@end
