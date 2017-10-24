//
//  QTUMDefaultTagCell.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 20.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const QTUMDefaultTagCellReuseIdentifire;

@interface QTUMDefaultTagCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
