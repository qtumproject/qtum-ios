//
//  QTUMParagrafTagCell.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 23.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTTAttributedLabel.h"
#import "DynamicHeightCellProtocol.h"

extern NSString * const QTUMParagrafTagCellReuseIdentifire;

@interface QTUMParagrafTagCell : UITableViewCell <DynamicHeightCellProtocol>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;

-(UIFont*)boldFont;
-(UIFont*)regularFont;
-(UIColor*)linkColor;
-(UIColor*)textColor;

@end
