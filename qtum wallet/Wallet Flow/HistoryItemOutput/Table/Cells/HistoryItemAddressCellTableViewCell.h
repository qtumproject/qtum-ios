//
//  HistoryItemAddressCellTableViewCell.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 06.04.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *HistoryItemAddressCellTableViewCellIdentifier = @"HistoryItemAddressCellTableViewCellIdentifier";

@interface HistoryItemAddressCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;

@end
