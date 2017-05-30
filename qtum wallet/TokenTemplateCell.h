//
//  TokenTemplateCell.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 23.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString* tokenTemplateCellIdentifire = @"TokenTemplateCellIdentifire";

@interface TokenTemplateCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *templateName;
@property (weak, nonatomic) IBOutlet UILabel *tokenIdentifire;
@property (weak, nonatomic) IBOutlet UIImageView *disclousureImage;
@property (weak, nonatomic) IBOutlet UILabel *creationDate;

@end
