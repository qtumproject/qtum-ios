//
//  AddressControlCell.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 02.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString* addressControlCellIdentifire = @"addressControlCellIdentifire";

@interface AddressControlCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;

@end
