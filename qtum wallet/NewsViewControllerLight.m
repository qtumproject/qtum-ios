//
//  NewsViewControllerLight.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 21.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NewsViewControllerLight.h"
#import "NewsTableCellLight.h"
#import "QTUMNewsItem.h"
#import "NSDate+Extension.h"

@interface NewsViewControllerLight ()

@property (strong, nonatomic) NSDateFormatter *cellFormatter;

@end

@implementation NewsViewControllerLight

-(NSDateFormatter *)cellFormatter {
    
    if (!_cellFormatter) {
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"MMM dd, YYYY hh:mm aa"];
        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[LanguageManager currentLanguageCode]]];
        _cellFormatter = formatter;
    }
    return _cellFormatter;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.news.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsTableCellLight *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsTableCellLight"];
    QTUMNewsItem* newsItem = self.news[indexPath.row];
    cell.descriptionLabel.text = newsItem.feed.title;
    cell.titleLabel.text = newsItem.feed.author;
    cell.dateLabel.text = [NSString stringWithFormat:@"%@", [self.cellFormatter stringFromDate:[newsItem.feed.date dateInLocalTimezoneFromUTCDate]]];
    
    return cell;
}

@end
