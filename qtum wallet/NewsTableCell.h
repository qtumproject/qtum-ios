//
//  NewsTableCell.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 07.02.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsCellModel.h"

@interface NewsTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *customImageView;
@property (weak, nonatomic) IBOutlet UILabel *customTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *customBottomLabel;

-(void)setContentWithDict:(NewsCellModel*) object;

@end
