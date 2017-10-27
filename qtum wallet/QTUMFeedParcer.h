//
//  QTUMFeedParcer.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QTUMFeedItem.h"
#import "Cancelable.h"

typedef void(^QTUMFeeds) (NSArray <QTUMFeedItem*>* feeds);

@interface QTUMFeedParcer : NSObject <Cancelable>

-(void)parceFeedFromUrl:(NSString*) url withCompletion:(QTUMFeeds) completion;

@end
