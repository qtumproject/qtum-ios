//
//  NewsDataProvider.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QTUMNewsItem.h"
#import "QTUMFeedParcer.h"
#import "QTUMHtmlParcer.h"

@interface NewsDataProvider : NSObject

typedef void(^QTUMNewsItems) (NSArray <QTUMNewsItem*>* feeds);

-(void)getNewsItemsWithCompletion:(QTUMNewsItems) completion;
-(void)getTagsFromNews:(QTUMNewsItem*) newsItem withCompletion:(QTUMTagsItems) completion;
-(NSArray <QTUMNewsItem*>*)obtainNewsItems;
-(void)cancelAllOperations;

+ (instancetype)sharedInstance;
- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

@end
