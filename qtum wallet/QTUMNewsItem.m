//
//  QTUMNewsItem.m
//  qtum wallet
//
//  Created by Никита Федоренко on 19.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QTUMNewsItem.h"


@interface QTUMNewsItem ()

@property (nonatomic, strong) NSArray<QTUMHTMLTagItem*>* tags;
@property (nonatomic, strong) QTUMFeedItem* feed;

@end

@implementation QTUMNewsItem

-(instancetype)initWithTags:(NSArray<QTUMHTMLTagItem*>*) tags andFeed:(QTUMFeedItem*) feed {
    
    self = [super init];
    if (self) {
        _tags = tags;
        _feed = feed;
    }
    return self;
}


@end
