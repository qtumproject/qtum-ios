//
//  HistoryItemViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 06.04.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryItemOutput.h"
#import "Presentable.h"

@interface HistoryItemViewController : BaseViewController <HistoryItemOutput, Presentable>

@property (weak, nonatomic) IBOutlet UITableView *owerviewTableView;
@property (weak, nonatomic) IBOutlet UITableView *eventLogTableView;

- (void)configWithItem;
- (void)configLocalization;

@end
