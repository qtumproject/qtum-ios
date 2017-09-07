//
//  BalanceTokenView.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 29.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BalanceTokenView : UIView

@property (weak, nonatomic) IBOutlet UILabel *balanceValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceTextLabel;
@property (copy, nonatomic) NSString *shortBalance;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintBalanceText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraintBalanceValue;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerConstraintBalanceText;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerConstraintBalanceValue;

@end
