//
//  ProfileTableViewCell.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 28.12.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const normalCellReuseIdentifire;
extern NSString *const separatorCellReuseIdentifire;
extern NSString *const switchCellReuseIdentifire;

@interface ProfileTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *diclousereImageView;
@property (weak, nonatomic) IBOutlet UILabel *profileCellTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileCellImage;
@property (weak, nonatomic) IBOutlet UISwitch *switchControl;

@end
