//
//  NewsDetailViewControllerDark.m
//  qtum wallet
//
//  Created by Никита Федоренко on 20.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NewsDetailViewControllerDark.h"
#import "QTUMDefaultTagCell.h"
#import "QTUMHTMLTagItem.h"
#import "QTUMNewsItem.h"
#import "NewsDetailCellBuilder.h"

@interface NewsDetailViewControllerDark ()

@end

@implementation NewsDetailViewControllerDark

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsItem.tags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QTUMHTMLTagItem* tag = self.newsItem.tags[indexPath.row];
    return [self.cellBuilder getCellWithTagItem:tag fromTable:tableView];
}

@end
