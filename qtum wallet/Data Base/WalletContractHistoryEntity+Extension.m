//
//  WalletContractHistoryEntity+Extension.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 12.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "WalletContractHistoryEntity+Extension.h"

@implementation WalletContractHistoryEntity (Extension) 

@dynamic contracted;


-(QTUMBigNumber*)amount {
    return [QTUMBigNumber decimalWithString:self.amountString];
}

- (NSString*)address {
    return self.contractAddress;
}

-(NSString*)fullDateString {
    
    CGFloat dateNumber = self.dateInerval;
    
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

-(NSString*)blockHash {
    return nil;
}

-(NSInteger)blockNumber {
    return 0;
}

-(NSNumber*)dateNumber {
    
    return [NSNumber numberWithInteger:self.dateInerval];
}

- (NSString *)shortDateString {
    
    CGFloat dateNumber = self.dateInerval;
    
    if (!dateNumber) {
        return @"";
    }
    
    NSTimeInterval dateTimeInterval = dateNumber;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateTimeInterval];
    NSTimeInterval nowTimeInterval = [[NSDate new] timeIntervalSince1970];
    
    NSTimeInterval difference = nowTimeInterval - dateTimeInterval;
    NSTimeInterval day = 24 * 60 * 60;
    NSTimeInterval currenDayTimeInterval = (long)nowTimeInterval % (long)day;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if (difference < currenDayTimeInterval) {
        dateFormatter.dateFormat = @"h:mm a";
        dateFormatter.AMSymbol = @"a.m.";
        dateFormatter.PMSymbol = @"p.m.";
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        
    } else {
        dateFormatter.dateFormat = @"MMM dd";
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    }
    
    return [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
}

- (NSString *)formattedDateStringSinceCome {
    
    CGFloat dateNumber = self.dateInerval;
    
    if (!dateNumber) {
        return @"";
    }
    
    NSTimeInterval dateTimeInterval = dateNumber;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateTimeInterval];
    NSDate *now = [NSDate date];
    
    NSDateComponentsFormatter *formatter = [[NSDateComponentsFormatter alloc] init];
    formatter.unitsStyle = NSDateComponentsFormatterUnitsStyleFull;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    calendar.locale = [NSLocale localeWithLocaleIdentifier:[LanguageManager currentLanguageCode]];
    
    NSDateComponents *components = [calendar components:(NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond)
                                               fromDate:date
                                                 toDate:now
                                                options:0];
    
    NSString *formatString;
    
    if (components.day >= 2) {
        
        return self.shortDateString;
        
    } else if (components.day == 1) {
        
        formatString = NSLocalizedString(@"Yesterday", @"day at history cell");
        return formatString;
        
    } else if (components.hour >= 1 && components.hour < 24) {
        
        return self.shortDateString;
        
    } else if (components.minute >= 1 && components.minute < 60) {
        
        NSString *minutsString = NSLocalizedString(@"minuts ago", @"time ago");
        NSString *minutString = NSLocalizedString(@"minut ago", @"time ago");
        
        return [NSString stringWithFormat:@"%li %@", (long)components.minute, components.minute > 1 ? minutsString : minutString];
        
    } else if (components.second > 0 && components.second < 60) {
        
        formatString = NSLocalizedString(@"few seconds ago", @"few seconds ago");
        return formatString;
    } else {
        return self.shortDateString;
    }
}

- (NSDictionary *)dictionaryFromElementForWatch {
    return nil;
}


- (BOOL)isEqualElementWithoutConfimation:(id<HistoryElementProtocol>)object {
    return YES;
}


- (void)setupWithObject:(id)object {
    
}



@end
