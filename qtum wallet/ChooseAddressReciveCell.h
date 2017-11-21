//
//  ChooseAddressReciveCell.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 23.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *chooseAddressReciveCellIdentifire = @"chooseAddressReciveCellIdentifire";

@interface ChooseAddressReciveCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end
