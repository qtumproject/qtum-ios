//
//  HistoryElement.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 21.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "HistoryElement.h"

@implementation HistoryElement

- (void)setAmount:(NSNumber *)amount
{
    _amount = amount;
    [self createAmountString];
}

- (void)setDateNumber:(NSNumber *)dateNumber
{
    _dateNumber = dateNumber;
    [self createDateString];
}

#pragma mark - Methods

- (void)createAmountString
{
    self.amountString  = [NSString stringWithFormat:@"%@ QTUM", [self.amount stringValue]];
}

- (void)createDateString
{
    NSTimeInterval dateTimeInterval = [self.dateNumber doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateTimeInterval];
    NSTimeInterval nowTimeInterval = [[NSDate new] timeIntervalSince1970];
    
    NSTimeInterval difference = nowTimeInterval - dateTimeInterval;
    
    NSTimeInterval day = 24 * 60 * 60;
    NSTimeInterval currenDayTimeInterval = (long)nowTimeInterval % (long)day;
    
    if (difference < currenDayTimeInterval) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"h:mm a";
        dateFormatter.AMSymbol = @"a.m.";
        dateFormatter.PMSymbol = @"p.m.";
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        
        self.dateString = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
        return;
    }
    
    if (difference < currenDayTimeInterval + day) {
        self.dateString = @"Yestarday";
        return;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMM dd";
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    self.dateString = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
}

@end
