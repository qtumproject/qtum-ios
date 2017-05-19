//
//  TokenCell.h
//  qtum wallet
//
//  Created by Никита Федоренко on 19.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString* tokenCellIdentifire = @"TokenCellIdentifire";

@interface TokenCell : UITableViewCell

-(void)setupWithObject:(id)object;

@end
