//
//  QTUMDefaultTagCell.h
//  qtum wallet
//
//  Created by Никита Федоренко on 20.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DynamicHeightCellProtocol.h"

extern NSString * const QTUMDefaultTagCellReuseIdentifire;

@interface QTUMDefaultTagCell : UITableViewCell <DynamicHeightCellProtocol>

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
