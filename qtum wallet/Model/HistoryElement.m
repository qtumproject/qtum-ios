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
    self.amountString  = [NSString stringWithFormat:@"%0.3f QTUM", [self.amount floatValue]];
}

- (void)createDateString{
    CGFloat dateNumber = [self.dateNumber doubleValue];
    if (!dateNumber) {
        return;
    }
    
    NSTimeInterval dateTimeInterval = dateNumber;
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

-(BOOL)isEqualElementWithoutConfimation:(HistoryElement*)object{
    if (![self.address isEqualToString:object.address] && self.address && object.address) {
        return NO;
    }
    if (![self.amount isEqualToNumber:object.amount] && self.amount && object.amount) {
        return NO;
    }
    if (![self.amountString isEqualToString:object.amountString] && self.amountString && object.amountString) {
        return NO;
    }
    if (![self.dateNumber isEqualToNumber:object.dateNumber] && self.dateNumber && object.dateNumber) {
        return NO;
    }
    if (![self.dateString isEqualToString:object.dateString] && self.dateString && object.dateString) {
        return NO;
    }
    if (!self.send == object.send) {
        return NO;
    }
    if (!self.confirmed == object.confirmed) {
        return YES;
    }
    return YES;
}

@end
