//
//  HistoryItemAddressCellTableViewCell.h
//  qtum wallet
//
//  Created by Никита Федоренко on 06.04.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *HistoryItemAddressCellTableViewCellIdentifier = @"HistoryItemAddressCellTableViewCellIdentifier";

@interface HistoryItemAddressCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end
