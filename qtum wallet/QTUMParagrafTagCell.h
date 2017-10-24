//
//  QTUMParagrafTagCell.h
//  qtum wallet
//
//  Created by Никита Федоренко on 23.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"

extern NSString * const QTUMParagrafTagCellReuseIdentifire;

@interface QTUMParagrafTagCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *contentLabel;

@end
