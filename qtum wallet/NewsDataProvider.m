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
        });
        
        weakSelf.htmlParcer = htmlParcer;
        
    }];

    self.parcer = parcer;
}



@end
