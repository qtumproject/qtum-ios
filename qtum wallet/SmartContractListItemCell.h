//
//  SmartContractListItemCell.h
//  qtum wallet
//
//  Created by Никита Федоренко on 30.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString* smartContractListItemCellIdentifire = @"SmartContractListItemCellIdentifire";

@interface SmartContractListItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contractName;
@property (weak, nonatomic) IBOutlet UILabel *typeIdentifire;
@property (weak, nonatomic) IBOutlet UILabel *creationDate;

@end
