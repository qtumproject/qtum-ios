//
//  NSDate+Extension.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
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
        return NSLocalizedString(@"Yestarday", @"day at history cell");
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMM dd";
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    return [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:self]];
}

- (NSString*)string {
    
    NSDateFormatter *fullDateFormater = [[NSDateFormatter alloc] init];
    fullDateFormater.dateFormat = @"Y-M-d hh:mm:ss";
    fullDateFormater.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    return [NSString stringWithFormat:@"%@", [fullDateFormater stringFromDate:self]];
}

@end
