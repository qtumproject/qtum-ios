//
//  QTUMTitleTagCell.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 09.11.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const QTUMTitleTagCellLightReuseIdentifire;

@interface QTUMTitleTagCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
