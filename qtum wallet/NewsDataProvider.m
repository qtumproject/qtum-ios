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
    
//    NSString* html = @"<figure><img alt=\"\" src=\"https://cdn-images-1.medium.com/max/900/1*QREmjdelFwDrkGmMiILYiQ.jpeg\"></figure><p>Wireline, the cloud application marketplace and pioneer of serverless architecture, is today announcing it will work with Qtum, the open-source blockchain project developed by the Singapore-based Qtum Foundation. The cooperation is a major step in creating the largest open-source ecosystem that will enable enterprises to consume microservices at scale using blockchain at its core.</p> <p>Microservices are revolutionizing the delivery of software; they offer the ability to rapidly create APIs without having to manage the underlying hardware and software infrastructure. Wireline is building an ecosystem based on a microservices exchange; it is a marketplace for enterprises to discover, test and integrate open-source apps, enabling them to build bespoke IT systems.</p> <p>Wireline is seeking to create the largest open-source developer fund, whereby developers building software critical for serverless architecture and the blockchain ecosystem are rewarded. The cooperation opens up new possibilities for both Qtum and Wireline developers for connecting distributed applications.</p> <blockquote>“Corporate IT is a huge market with global spend approaching $1.5 trillion, but until now there’s been little reward for developing open-source software because of stifling competition from industry giants,” says Lucas Geiger, CEO at Wireline. “With Qtum we want to change this. Through the combination of both our efforts through the Qtum Foundation and Wireline Developer Fund, we will create an opportunity to monetize existing apps as well as support the creation of new ones.”</blockquote> <p>Qtum aims to establish a platform designed to bridge the still-existing gap between blockchains and the business world. Qtum’s strategy includes providing a toolset to standardize the workflow of businesses and a hub of tested and verified smart contract templates that address various specialized business-use cases.</p> <blockquote>“We’re excited to collaborate with Wireline as we have a shared mission — to decentralize the application market and create a platform to facilitate the use of blockchain in business,” says Patrick Dai, co-founder and chairman of the Qtum Foundation. “We think this is beneficial to our developer community and will dramatically reduce the time to market for many of their apps.”</blockquote> <img src=\"https://medium.com/_/stat?event=post.clientViewed&amp;referrerSource=full_rss&amp;postId=9db9f330c63a\" width=\"1\" height=\"1\"><hr> <p><a href=\"https://blog.qtum.org/wireline-and-qtum-to-pioneer-the-next-generation-of-cloud-computing-9db9f330c63a\">Wireline And Qtum To Pioneer The Next Generation Of Cloud Computing</a> was originally published in <a href=\"https://blog.qtum.org/\">Qtum</a> on Medium, where people are continuing the conversation by highlighting and responding to this story.</p> \"\n\"content\": \" <figure><img alt=\"\" src=\"https://cdn-images-1.medium.com/max/900/1*QREmjdelFwDrkGmMiILYiQ.jpeg\"></figure><p>Wireline, the cloud application marketplace and pioneer of serverless architecture, is today announcing it will work with Qtum, the open-source blockchain project developed by the Singapore-based Qtum Foundation. The cooperation is a major step in creating the largest open-source ecosystem that will enable enterprises to consume microservices at scale using blockchain at its core.</p> <p>Microservices are revolutionizing the delivery of software; they offer the ability to rapidly create APIs without having to manage the underlying hardware and software infrastructure. Wireline is building an ecosystem based on a microservices exchange; it is a marketplace for enterprises to discover, test and integrate open-source apps, enabling them to build bespoke IT systems.</p> <p>Wireline is seeking to create the largest open-source developer fund, whereby developers building software critical for serverless architecture and the blockchain ecosystem are rewarded. The cooperation opens up new possibilities for both Qtum and Wireline developers for connecting distributed applications.</p> <blockquote>“Corporate IT is a huge market with global spend approaching $1.5 trillion, but until now there’s been little reward for developing open-source software because of stifling competition from industry giants,” says Lucas Geiger, CEO at Wireline. “With Qtum we want to change this. Through the combination of both our efforts through the Qtum Foundation and Wireline Developer Fund, we will create an opportunity to monetize existing apps as well as support the creation of new ones.”</blockquote> <p>Qtum aims to establish a platform designed to bridge the still-existing gap between blockchains and the business world. Qtum’s strategy includes providing a toolset to standardize the workflow of businesses and a hub of tested and verified smart contract templates that address various specialized business-use cases.</p> <blockquote>“We’re excited to collaborate with Wireline as we have a shared mission — to decentralize the application market and create a platform to facilitate the use of blockchain in business,” says Patrick Dai, co-founder and chairman of the Qtum Foundation. “We think this is beneficial to our developer community and will dramatically reduce the time to market for many of their apps.”</blockquote> <img src=\"https://medium.com/_/stat?event=post.clientViewed&amp;referrerSource=full_rss&amp;postId=9db9f330c63a\" width=\"1\" height=\"1\"><hr> <p><a href=\"https://blog.qtum.org/wireline-and-qtum-to-pioneer-the-next-generation-of-cloud-computing-9db9f330c63a\">Wireline And Qtum To Pioneer The Next Generation Of Cloud Computing</a> was originally published in <a href=\"https://blog.qtum.org/\">Qtum</a> on Medium, where people are continuing the conversation by highlighting and responding to this story.</p>";
//
//    html = [NSString stringWithFormat:@"<div class=\"medium-parcing-container\">%@</div>",html];
//
//    NSData *tutorialsHtmlData = [html dataUsingEncoding:NSUTF8StringEncoding];
//
//    // 2
//    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:tutorialsHtmlData];
//
//    // 3
//    NSString *tutorialsXpathQueryString = @"//div[@class='medium-parcing-container']";
//    NSArray *tutorialsNodes = [tutorialsParser searchWithXPathQuery:tutorialsXpathQueryString];
    
    QTUMFeedParcer* parcer = [[QTUMFeedParcer alloc] init];
    [parcer parceFeedFromUrl:@"https://medium.com/feed/@Qtum" withCompletion:^(NSArray<QTUMFeedItem *> *feeds) {
        
        QTUMHtmlParcer* htmlParcer = [[QTUMHtmlParcer alloc] init];
        
        for (QTUMFeedItem* feedItem in feeds) {
            
            [htmlParcer parceNewsFromHTMLString:feedItem.summary withCompletion:^(NSArray<QTUMHTMLTagItem *> *feeds) {
                
            }];
        }
        
        self.htmlParcer = htmlParcer;
        
    }];
    self.parcer = parcer;
    
    


}



@end
