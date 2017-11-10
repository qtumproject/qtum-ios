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
typedef void(^gettingNewsFailedBlock)(void);


-(void)getNewsItemsWithCompletion:(QTUMNewsItems) completion andFailure:(gettingNewsFailedBlock) failure;
-(void)getTagsFromNews:(QTUMNewsItem*) newsItem withCompletion:(QTUMTagsItems) completion;
-(NSArray <QTUMNewsItem*>*)obtainNewsItems;
-(void)cancelAllOperations;

@end
