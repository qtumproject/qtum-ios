//
//  ProfileTableViewCell.h
//  qtum wallet
//
//  Created by Никита Федоренко on 28.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *diclousereImageView;
@property (weak, nonatomic) IBOutlet UILabel *profileCellTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileCellImage;

@end
