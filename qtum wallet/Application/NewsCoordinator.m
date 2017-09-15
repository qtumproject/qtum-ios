//
//  NewsCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 02.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "NewsCoordinator.h"
#import "NewsCellModel.h"
#import "NewsOutput.h"
#import "NewsTableSourceOutput.h"

@interface NewsCoordinator () <NewsOutputDelegate>

@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) NSObject<NewsTableSourceOutput> *newsTableSource;
@property (weak, nonatomic) NSObject<NewsOutput> *newsController;

@end

@implementation NewsCoordinator

-(instancetype)initWithNavigationController:(UINavigationController*)navigationController{
    self = [super init];
    if (self) {
        _navigationController = navigationController;
    }
    return self;
}

#pragma mark - Coordinatorable

-(void)start {
    
    self.newsController = (NSObject<NewsOutput> *)self.navigationController.viewControllers[0];
    self.newsTableSource = [[TableSourcesFactory sharedInstance] createNewsSource];
    
    self.newsTableSource.dataArray = @[];
    self.newsController.tableSource = self.newsTableSource;
    self.newsController.delegate = self;
}

#pragma mark - NewsOutputDelegate

-(void)refreshTableViewData{
    __weak __typeof(self) weakSelf = self;
    [[ApplicationCoordinator sharedInstance].requestManager getNews:^(id responseObject) {
        [weakSelf parceResponse:responseObject];
        [weakSelf.newsController reloadTableView];
    } andFailureHandler:^(NSError *error, NSString *message) {
        [weakSelf.newsController failedToGetData];
    }];
}

-(void)openNewsLink {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://medium.com/@Qtum/"]];
}

#pragma mark - Private Methods

-(void)parceResponse:(id)response{
    if (!response || ![response isKindOfClass:[NSArray class]]) { return; }
    NSMutableArray* dataArray = @[].mutableCopy;
    for (id item in response) {
        NewsCellModel* object = [[NewsCellModel alloc] initWithDict:item];
        [dataArray addObject:object];
    }
    self.newsTableSource.dataArray = dataArray;
}


@end
