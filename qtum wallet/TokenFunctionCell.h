//
//  TokenFunctionCell.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbiinterfaceItem.h"

static NSString* tokenFunctionCellIdentifire = @"tokenFunctionCellIdentifire";

@interface TokenFunctionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *disclousere;
@property (weak, nonatomic) IBOutlet UILabel *functionName;

-(void)setupWithObject:(id)object;

@end
