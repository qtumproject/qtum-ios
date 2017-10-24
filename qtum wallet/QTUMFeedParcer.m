//
//  QTUMFeedParcer.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QTUMFeedParcer.h"
#import "MWFeedParser.h"

@interface QTUMFeedParcer () <MWFeedParserDelegate>

@property (nonatomic, copy) QTUMFeeds completion;
@property (nonatomic, strong) MWFeedParser* feedParcer;
@property (nonatomic, strong) NSMutableArray* feedItems;
@property (nonatomic, strong) NSOperationQueue* workingQueue;


@end

@implementation QTUMFeedParcer

#pragma mark - Custom Accessors

-(NSMutableArray*)feedItems {
    
    if (!_feedItems) {
        _feedItems = @[].mutableCopy;
    }
    return _feedItems;
}

-(NSOperationQueue*)workingQueue {
    
    if (!_workingQueue) {
        _workingQueue = [[NSOperationQueue alloc] init];
        _workingQueue.maxConcurrentOperationCount = 1;
    }
    return _workingQueue;
}
#pragma mark - Public

-(void)parceFeedFromUrl:(NSString*) url withCompletion:(QTUMFeeds) completion {
    
    __weak __typeof(self)weakSelf = self;
    
    dispatch_block_t block = ^{

        NSURL *feedURL = [NSURL URLWithString:url];
        MWFeedParser *feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
        feedParser.delegate = weakSelf;
        feedParser.feedParseType = ParseTypeFull;
        feedParser.connectionType = ConnectionTypeSynchronously;
        [feedParser parse];
        weakSelf.feedParcer = feedParser;
    };

    self.completion = completion;
    [self.workingQueue addOperationWithBlock:block];
}

#pragma mark - Private

#pragma mark - MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
    
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
    
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    
    __weak __typeof(self)weakSelf = self;

    dispatch_block_t block = ^{
        
        [weakSelf.feedItems addObject:item];
    };
    
    [self.workingQueue addOperationWithBlock:block];

}

- (void)feedParserDidFinish:(MWFeedParser *)parser{
    
    __weak __typeof(self)weakSelf = self;
    
    dispatch_block_t block = ^{
        
        NSMutableArray<QTUMFeedItem*>* qtumFeeds= @[].mutableCopy;
        
        for (MWFeedItem* item in weakSelf.feedItems) {
            QTUMFeedItem* qtumFeed = [[QTUMFeedItem alloc] initWithItem:item];
            [qtumFeeds addObject:qtumFeed];
        }
        
        if (weakSelf.completion) {
            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                weakSelf.completion(qtumFeeds);
//            });
            weakSelf.completion(qtumFeeds);

        }
    };
    
    [self.workingQueue addOperationWithBlock:block];
}

- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error{; // Parsing failed}
}

@end
