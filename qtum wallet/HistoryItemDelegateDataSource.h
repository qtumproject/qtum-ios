//
//  HistoryItemDelegateDataSource.h
//  qtum wallet
//
//  Created by Никита Федоренко on 06.04.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HistoryElement;

@interface HistoryItemDelegateDataSource : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic)HistoryElement* item;

@end
