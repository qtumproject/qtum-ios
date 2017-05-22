//
//  NewsTableCell.h
//  qtum wallet
//
//  Created by Никита Федоренко on 07.02.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsCellModel.h"

@interface NewsTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *customImageView;
@property (weak, nonatomic) IBOutlet UILabel *customTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *customBottomLabel;

-(void)setContentWithDict:(NewsCellModel*) object;

@end
