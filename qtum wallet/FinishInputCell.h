//
//  FinishInputCell.h
//  qtum wallet
//
//  Created by Никита Федоренко on 17.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString* FinishInputCellIdentifire = @"FinishInputCellIdentifire";

@interface FinishInputCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *value;

-(void)setContentWithDict:(id) object;

@end
