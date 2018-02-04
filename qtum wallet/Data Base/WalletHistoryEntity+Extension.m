//
//  WalletHistoryEntity+Extension.m
//  qtum wallet
//
//  Created by Fedorenko Nikita on 01.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "WalletHistoryEntity+Extension.h"

@implementation WalletHistoryEntity (Extension)

- (NSDictionary *)dictionaryFromElementForWatch {
    return nil;
}

- (NSString *)formattedDateStringSinceCome {
    return @"";
}

- (BOOL)isEqualElementWithoutConfimation:(id<HistoryElementProtocol>)object {
    return NO;
}

- (void)setupWithObject:(id)object {
    
}

-(QTUMBigNumber*)amount {
    return [QTUMBigNumber decimalWithString:self.amountString];
}

-(NSString*)shortDateString {
    return @"";
}

-(NSString*)fullDateString {
    return @"";
}


@end
