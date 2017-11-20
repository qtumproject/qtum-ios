//
//  NSDate+Extension.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

- (NSString*)formatedDateString{
    
    NSTimeInterval dateTimeInterval = [self timeIntervalSince1970];
    NSTimeInterval nowTimeInterval = [[NSDate new] timeIntervalSince1970];
    
    NSTimeInterval difference = nowTimeInterval - dateTimeInterval;
    
    NSTimeInterval day = 24 * 60 * 60;
    NSTimeInterval currenDayTimeInterval = (long)nowTimeInterval % (long)day;
    
    NSDateFormatter *fullDateFormater = [[NSDateFormatter alloc] init];
    fullDateFormater.dateFormat = @"MMMM d, hh:mm:ss aa";
    fullDateFormater.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    
    if (difference < currenDayTimeInterval) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"h:mm a";
        dateFormatter.AMSymbol = @"a.m.";
        dateFormatter.PMSymbol = @"p.m.";
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        
        return [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:self]];
    }
    
    if (difference < currenDayTimeInterval + day) {
        return NSLocalizedString(@"Yesterday", @"day at history cell");
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMM dd";
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    return [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:self]];
}

- (NSString*)string {
    
    NSDateFormatter *fullDateFormater = [[NSDateFormatter alloc] init];
    fullDateFormater.dateFormat = @"Y-MM-dd HH:mm:ss";
    fullDateFormater.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    return [NSString stringWithFormat:@"%@", [fullDateFormater stringFromDate:self]];
}

+ (NSString*)formatedDateStringFromString:(NSString*)dateString {
    
    NSDateFormatter *fullDateFormater = [[NSDateFormatter alloc] init];
    fullDateFormater.dateFormat = @"Y-MM-dd HH:mm:ss";
    fullDateFormater.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    
    return [[fullDateFormater dateFromString:dateString] formatedDateString];
}

+ (NSInteger)minutsSinceDate :(NSDate *)date {
    
    NSInteger secondInMinut = 60;
    NSDate *currentTime = [NSDate date];
    double secondsSinceDate = [currentTime timeIntervalSinceDate:date];
    return (NSInteger) secondsSinceDate / secondInMinut;
}

- (NSDate*)dateInLocalTimezoneFromUTCDate {
    
    NSDate *someDateInUTC = self;
    NSTimeInterval timeZoneSeconds = [[NSTimeZone localTimeZone] secondsFromGMT];
    NSDate *dateInLocalTimezone = [someDateInUTC dateByAddingTimeInterval:timeZoneSeconds];
    return dateInLocalTimezone;
}

@end
