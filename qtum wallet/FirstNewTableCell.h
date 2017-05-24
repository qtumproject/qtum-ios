//
//  FirstNewTableCell.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 09.02.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsCellModel.h"

@interface FirstNewTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *customImage;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *shortDiscriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *longDiscriptionLabel;

-(void)setContentWithDict:(NewsCellModel*) object;

@end
