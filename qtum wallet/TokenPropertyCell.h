//
//  TokenPropertyCell.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 23.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbiinterfaceItem.h"


static NSString* tokenPropertyCelldentifire = @"tokenPropertyCelldentifire";

@interface TokenPropertyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *propertyName;
@property (weak, nonatomic) IBOutlet UILabel *propertyValue;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

-(void)setupWithObject:(AbiinterfaceItem*)object andToken:(Contract*) token;

@end
