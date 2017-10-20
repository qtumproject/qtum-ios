//
//  QTUMImageTagCell.h
//  qtum wallet
//
//  Created by Никита Федоренко on 20.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const QTUMImageTagCellReuseIdentifire;

@interface QTUMImageTagCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *tagImageView;

@end
