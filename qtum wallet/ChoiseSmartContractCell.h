//
//  ChoiseSmartContractCell.h
//  qtum wallet
//
//  Created by Никита Федоренко on 30.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString* choiseSmartContractCellIdentifire = @"ChoiseSmartContractCellIdentifire";

@interface ChoiseSmartContractCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *smartContractType;
@property (weak, nonatomic) IBOutlet UIImageView *disclosure;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
