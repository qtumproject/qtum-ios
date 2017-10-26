//
//  QTUMNewsItem.h
//  qtum wallet
//
//  Created by Никита Федоренко on 19.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QTUMFeedItem.h"
#import "QTUMHTMLTagItem.h"

@interface QTUMNewsItem : NSObject <NSCoding>

@property (nonatomic, strong) NSArray<QTUMHTMLTagItem*>* tags;
@property (nonatomic, strong, readonly) QTUMFeedItem* feed;
@property (nonatomic, strong, readonly) NSString* identifire;

-(instancetype)initWithTags:(NSArray<QTUMHTMLTagItem*>*) tags andFeed:(QTUMFeedItem*) feed;

@end
