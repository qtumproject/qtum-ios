//
//  HistoryAddressesHeaderCell.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 06.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *headerReuseIdentifire = @"HeaderCell";

@interface HistoryAddressesHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *headerTextLabel;

@end
