//
//  HistoryItemHeaderView.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 06.04.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *HistoryItemHeaderViewIdentifier = @"HistoryItemHeaderViewIdentifier";

@interface HistoryItemHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *headerTextLabel;

@end
