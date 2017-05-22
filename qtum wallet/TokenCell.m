//
//  TokenCell.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "TokenCell.h"
#import "Token.h"

@interface TokenCell ()

@property (weak, nonatomic) IBOutlet UILabel *tokenName;
@property (weak, nonatomic) IBOutlet UILabel *mainSymbol;
@property (weak, nonatomic) IBOutlet UILabel *symbol;
@property (weak, nonatomic) IBOutlet UILabel *mainValue;
@property (weak, nonatomic) IBOutlet UILabel *value;

@end

@implementation TokenCell

-(void)setupWithObject:(Token *)token {
    
    self.tokenName.text = token.name;
    self.mainSymbol.text = @"QTUM";
    self.symbol.text = @"QTUM";
    self.mainValue.text = [NSString stringWithFormat:@"%f",token.balance];
}

@end
