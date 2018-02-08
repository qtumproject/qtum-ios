//
//  HistoryEventLogAddressCell.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 07.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *historyEventLogAddressCellIdentifier = @"historyEventLogAddressCellIdentifier";

@interface HistoryEventLogAddressCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueTextLabel;

- (void)sizeToFitLabels;

@end
