//
//  NewsDataProvider.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NewsDataProvider.h"
#import "NetworkingService.h"
#import "NSString+HTML.h"
#import "TFHpple.h"
#import "QTUMFeedParcer.h"
#import "QTUMHtmlParcer.h"

@interface NewsDataProvider ()

@property (strong, nonatomic) NetworkingService* networkService;
@property (strong, nonatomic) QTUMFeedParcer* parcer;
@property (strong, nonatomic) QTUMHtmlParcer* htmlParcer;
@property (nonatomic, copy) QTUMNewsItems completion;
@property (strong, nonatomic) NSArray <QTUMNewsItem*>* news;
@property (nonatomic, strong) NSOperationQueue* storingQueue;

@end

@implementation NewsDataProvider

+ (instancetype)sharedInstance {
    
    static NewsDataProvider *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] initUniqueInstance];
    });
    return instance;
}

- (instancetype)initUniqueInstance {
    
    self = [super init];
    
    if (self != nil) {
        
        _networkService = [[NetworkingService alloc] initWithBaseUrl:@"https://api.medium.com/v1"];
        _networkService.accesToken = @"2df96f4271bd76950229972d74a9bc6d456bfae100b1201c90a8947f647733343";
    }
    return self;
}

#pragma mark - Custom Accessors

-(NSOperationQueue*)storingQueue {
    
    if (!_storingQueue) {
        _storingQueue = [[NSOperationQueue alloc] init];
        _storingQueue.maxConcurrentOperationCount = 1;
    }
    return _storingQueue;
}

-(void)getNewsItemsWithCompletion:(QTUMNewsItems) completion {
    
    self.completion = completion;
    
    __weak __typeof(self)weakSelf = self;
    
    NSMutableArray <QTUMNewsItem*>* news = @[].mutableCopy;
    
    dispatch_group_t downloadGoup = dispatch_group_create();

    QTUMFeedParcer* parcer = [[QTUMFeedParcer alloc] init];
    
    //1 parcing feed from medium

    [parcer parceFeedFromUrl:@"https://medium.com/feed/@Qtum" withCompletion:^(NSArray<QTUMFeedItem *> *feeds) {
        
        QTUMHtmlParcer* htmlParcer = [[QTUMHtmlParcer alloc] init];
        
        //2 parcing html from each feed
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        for (QTUMFeedItem* feedItem in feeds) {
            
            dispatch_group_enter(downloadGoup);
            
            //3 creating news objects

            [htmlParcer parceNewsFromHTMLString:feedItem.summary withCompletion:^(NSArray<QTUMHTMLTagItem *> *tags) {
                
                QTUMFeedItem* feedItemBlock = feedItem;
                
                dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    QTUMNewsItem* newsItem = [[QTUMNewsItem alloc] initWithTags:tags andFeed:feedItemBlock];
                    [news addObject:newsItem];
                    
                    dispatch_semaphore_signal(semaphore);
                    dispatch_group_leave(downloadGoup);
                });
                
            }];
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
        
        dispatch_group_notify(downloadGoup, dispatch_get_main_queue(),^{
            
            //4 return created news
            if (weakSelf.completion) {
                weakSelf.completion(news);
            }

            [weakSelf storeNews:news];
        });
        
        weakSelf.htmlParcer = htmlParcer;
    }];

    self.parcer = parcer;
}

-(NSArray <QTUMNewsItem*>*)obtainNewsItems {
    
    if (!self.news) {
        [self unarchiveNews];
    }
    return self.news;
}

-(void)storeNews:(NSArray <QTUMNewsItem*>*) news {
    
    __weak __typeof(self)weakSelf = self;
    
    dispatch_block_t block = ^{
        
        NSDictionary* oldNews = [weakSelf createDictWithNews:weakSelf.news];
        NSDictionary* newNews = [weakSelf createDictWithNews:news];
        NSMutableDictionary* uniqueNews = [oldNews mutableCopy];
        [uniqueNews addEntriesFromDictionary:newNews];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:uniqueNews];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"kArchivedNewsDict"];
        
        weakSelf.news = [weakSelf sortNews:[uniqueNews allValues]];
    };
    
    [self.storingQueue addOperationWithBlock:block];
}

-(void)unarchiveNews {
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"kArchivedNewsDict"];
    NSDictionary *newsDict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (newsDict) {
        self.news = [self sortNews:[newsDict allValues]];
    }
}

-(NSDictionary<NSString*,NSArray <QTUMNewsItem*>*>*)createDictWithNews:(NSArray <QTUMNewsItem*>*) news {
    
    NSMutableDictionary* newsDict = @{}.mutableCopy;
    for (QTUMNewsItem* newsItem in news) {
        [newsDict setObject:newsItem forKey:newsItem.identifire];
    }
    
    return [newsDict copy];
}

-(NSArray <QTUMNewsItem*>*)sortNews:(NSArray <QTUMNewsItem*>*) news {
    
    NSArray *sortedArray = [news sortedArrayUsingComparator:^NSComparisonResult(QTUMNewsItem* news1, QTUMNewsItem* news2) {
        
        return [news2.feed.date compare:news1.feed.date];
    }];
    
    return sortedArray;
}


@end
