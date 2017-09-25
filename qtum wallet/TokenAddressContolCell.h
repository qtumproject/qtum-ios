//
//  TokenAddressContolCell.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString* tokenAddressControlCellIdentifire = @"tokenAddressControlCellIdentifire";

@interface TokenAddressContolCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;
@property (weak, nonatomic) NSString *shortBalance;

@end
