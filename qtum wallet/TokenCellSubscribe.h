//
//  TokenCellSubscribe.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.03.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *tokenCellIdentifire = @"TokenCellSubscribeIdentifire";

@interface TokenCellSubscribe : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *topSeparator;
@property (weak, nonatomic) IBOutlet UIImageView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
