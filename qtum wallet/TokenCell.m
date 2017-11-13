//
//  TokenCell.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "TokenCell.h"
#import "Contract.h"

@interface TokenCell ()

@property (weak, nonatomic) Contract* token;

@end

@implementation TokenCell

-(void)setupWithObject:(Contract *)token {
    
    self.tokenName.text = token.localName;
    self.mainSymbol.text = token.symbol;
    self.symbol.text = token.symbol;
    self.mainValue.text = [token balanceString];
    self.token = token;
}

- (void)changeHighlight:(BOOL)value { }

-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGSize size = [self.token.balanceString sizeWithAttributes:@{NSFontAttributeName : self.mainValue.font}];
    if (size.width > self.mainValue.bounds.size.width) {
        self.mainValue.text = [self.token shortBalanceString];
    } else {
        self.mainValue.text = [self.token balanceString];
    }
}

-(void)prepareForReuse {
    self.token = nil;
}

@end
