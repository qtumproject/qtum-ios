//
//  NewsTableCell.h
//  qtum wallet
//
//  Created by Никита Федоренко on 07.02.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsCellModel.h"

@interface NewsTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


-(void)setContentWithDict:(NewsCellModel*) object;

@end
