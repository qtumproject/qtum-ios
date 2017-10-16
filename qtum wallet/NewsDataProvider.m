//
//  NewsDataProvider.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NewsDataProvider.h"
#import "NetworkingService.h"
#import "MWFeedParser.h"
#import "NSString+HTML.h"

@interface NewsDataProvider () <MWFeedParserDelegate>
@property (strong, nonatomic) NetworkingService* networkService;
@property (strong, nonatomic) MWFeedParser* feedParcer;

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
        
        [self authorise];
        _networkService = [[NetworkingService alloc] initWithBaseUrl:@"https://api.medium.com/v1"];
        _networkService.accesToken = @"2df96f4271bd76950229972d74a9bc6d456bfae100b1201c90a8947f647733343";
        [self authorise];
    }
    return self;
}

-(void)authorise {
    
//    [self.networkService requestWithType:GET path:@"me" andParams:nil withSuccessHandler:^(id  _Nonnull responseObject) {
//
//    } andFailureHandler:^(NSError * _Nonnull error, NSString * _Nullable message) {
//
//    }];
    
    NSURL *feedURL = [NSURL URLWithString:@"https://medium.com/feed/@vladimir_60349"];
    MWFeedParser *feedParser = [[MWFeedParser alloc] initWithFeedURL:feedURL];
    feedParser.delegate = self;
    feedParser.feedParseType = ParseTypeFull;
    feedParser.connectionType = ConnectionTypeSynchronously;
    [feedParser parse];
    self.feedParcer = feedParser;
}

-(void)getAllMyPosts {
    
    [self.networkService requestWithType:GET path:@"me" andParams:nil withSuccessHandler:^(id  _Nonnull responseObject) {
        
    } andFailureHandler:^(NSError * _Nonnull error, NSString * _Nullable message) {
        
    }];
}

#pragma mark - MWFeedParserDelegate

- (void)feedParserDidStart:(MWFeedParser *)parser {
    
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedInfo:(MWFeedInfo *)info {
    
}
- (void)feedParser:(MWFeedParser *)parser didParseFeedItem:(MWFeedItem *)item {
    
    NSAttributedString* str = [[NSAttributedString alloc] initWithData:[item.summary dataUsingEncoding:NSUTF8StringEncoding]
                                     options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                               NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                          documentAttributes:nil error:nil];
    DLog(@"%@", str);
    
}
- (void)feedParserDidFinish:(MWFeedParser *)parser{
    
}
    
- (void)feedParser:(MWFeedParser *)parser didFailWithError:(NSError *)error{; // Parsing failed}
}

@end
