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

@end

@implementation TokenCell

-(void)setupWithObject:(Contract *)token {
    
    self.tokenName.text = token.localName;
    self.mainSymbol.text = NSLocalizedString(@"QTUM", @"");
    self.symbol.text = NSLocalizedString(@"QTUM", @"");
    self.mainValue.text = [NSString stringWithFormat:@"%f",token.balance];
}

- (void)changeHighlight:(BOOL)value { }

@end
