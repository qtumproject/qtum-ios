//
//  NewsViewControllerDark.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 21.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NewsViewControllerDark.h"
#import "NewsTableCellDark.h"
#import "QTUMNewsItem.h"

@interface NewsViewControllerDark ()

@property (strong, nonatomic) NSDateFormatter *cellFormatter;

@end

@implementation NewsViewControllerDark

#pragma mark - Custom Accessors

-(UIColor*)logoColor {
    return customBlueColor();
}

-(NSDateFormatter *)cellFormatter {
    
    if (!_cellFormatter) {
        NSDateFormatter *formatter = [NSDateFormatter new];
        [formatter setDateFormat:@"dd MMM"];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:[LanguageManager currentLanguageCode]]];
        _cellFormatter = formatter;
    }
    return _cellFormatter;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.news.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsTableCellDark *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsTableCellDark"];
    QTUMNewsItem* newsItem = self.news[indexPath.row];
    cell.descriptionLabel.text = newsItem.feed.title;
    cell.titleLabel.text = newsItem.feed.author;
    cell.dateLabel.text = [NSString stringWithFormat:@"%@", [self.cellFormatter stringFromDate:newsItem.feed.date]];
    
    return cell;
}

#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsTableCellDark* cell = (NewsTableCellDark*)[tableView cellForRowAtIndexPath:indexPath];
    cell.descriptionLabel.textColor = customBlackColor();
    cell.titleLabel.textColor = customBlackColor();
    cell.dateLabel.textColor = customBlackColor();
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsTableCellDark* cell = (NewsTableCellDark*)[tableView cellForRowAtIndexPath:indexPath];
    cell.descriptionLabel.textColor = customBlueColor();
    cell.titleLabel.textColor = customBlueColor();
    cell.dateLabel.textColor = customBlueColor();
}

@end
