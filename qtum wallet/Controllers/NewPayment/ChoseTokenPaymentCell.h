//
//  ChoseTokenPaymentCell.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 25.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString* choseTokenPaymentCellIdentifire = @"ChoseTokenPaymentCellIdentifire";

@interface ChoseTokenPaymentCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *tokenName;
@property (weak, nonatomic) IBOutlet UILabel *mainBalance;
@property (weak, nonatomic) IBOutlet UILabel *mainBalanceSymbol;
@property (weak, nonatomic) IBOutlet UILabel *balance;
@property (weak, nonatomic) IBOutlet UILabel *balanceSymbol;
@property (strong, nonatomic) NSString *shortBalance;


@end
