//
//  WalletBalanceEntity+Extension.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 08.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "WalletBalanceEntity+Extension.h"

@implementation WalletBalanceEntity (Extension)

-(QTUMBigNumber*)balance {
    
    QTUMBigNumber* balance = [QTUMBigNumber decimalWithString:self.balanceString];
    return balance ?: [QTUMBigNumber decimalWithString:@"0"];
}

-(QTUMBigNumber*)unconfirmedBalance {
    
    QTUMBigNumber* balance = [QTUMBigNumber decimalWithString:self.unconfirmedBalanceString];
    return balance ?: [QTUMBigNumber decimalWithString:@"0"];
}

-(NSString*)fullDateString {
    
    CGFloat dateNumber = self.dateInterval;
    
    if (!dateNumber) {
        return @"";
    }
    
    NSTimeInterval dateTimeInterval = dateNumber;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateTimeInterval];
    
    NSDateFormatter *fullDateFormater = [[NSDateFormatter alloc] init];
    fullDateFormater.dateFormat = @"MMMM d, hh:mm:ss aa";
    fullDateFormater.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    return [NSString stringWithFormat:@"%@", [fullDateFormater stringFromDate:date]];
}

@end
