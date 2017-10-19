//
//  QTUMFeedItem.m
//  qtum wallet
//
//  Created by Никита Федоренко on 19.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QTUMFeedItem.h"

@interface QTUMFeedItem()

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSDate *updated;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSArray *enclosures;

@end

@implementation QTUMFeedItem

-(instancetype)initWithItem:(MWFeedItem*) feedItem {
    
    self = [super init];
    
    if (self) {
        _identifier = feedItem.identifier;
        _title = feedItem.title;
        _link = feedItem.link;
        _date = feedItem.date;
        _updated = feedItem.updated;
        _summary = feedItem.summary;
        _content = feedItem.content;
        _author = feedItem.author;
        _enclosures = feedItem.enclosures;
    }
    
    return self;
}

@end
