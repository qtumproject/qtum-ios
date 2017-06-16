//
//  TokenCell.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "TokenCell.h"
#import "Contract.h"

@interface TokenCell ()

@property (weak, nonatomic) IBOutlet UILabel *tokenName;
@property (weak, nonatomic) IBOutlet UILabel *mainSymbol;
@property (weak, nonatomic) IBOutlet UILabel *symbol;
@property (weak, nonatomic) IBOutlet UILabel *mainValue;
@property (weak, nonatomic) IBOutlet UILabel *value;

@end

@implementation TokenCell

-(void)setupWithObject:(Contract *)token {
    
    self.tokenName.text = token.localName;
    self.mainSymbol.text = @"QTUM";
    self.symbol.text = @"QTUM";
    self.mainValue.text = [NSString stringWithFormat:@"%f",token.balance];
}

@end
