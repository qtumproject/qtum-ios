//
//  NewsCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 02.03.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NewsCoordinator.h"
#import "NewsCellModel.h"
#import "NewsOutput.h"
#import "NewsDetailOutput.h"
#import "NewsDataProvider.h"
#import "NewsDetailCellBuilder.h"

@interface NewsCoordinator () <NewsOutputDelegate>

@property (strong, nonatomic) UINavigationController *navigationController;
@property (weak, nonatomic) NSObject<NewsOutput> *newsController;

@end

@implementation NewsCoordinator

-(instancetype)initWithNavigationController:(UINavigationController*)navigationController {
    
    self = [super init];
    if (self) {
        _navigationController = navigationController;
    }
    return self;
}

#pragma mark - Coordinatorable

-(void)start {
    
    NSObject<NewsOutput> *newsOutput = [[ControllersFactory sharedInstance] createNewsOutput];
    newsOutput.delegate = self;
    [self.navigationController setViewControllers:@[[newsOutput toPresent]]];
    self.newsController = newsOutput;
}

#pragma mark - NewsOutputDelegate

-(void)refreshTableViewData {
    
    __weak __typeof(self) weakSelf = self;
    [[NewsDataProvider sharedInstance] getNewsItemsWithCompletion:^(NSArray<QTUMNewsItem *> *news) {
        weakSelf.newsController.news = news;
        [weakSelf.newsController reloadTableView];
    }];
}

-(void)didSelectCellWithNews:(QTUMNewsItem*) newsItem {
    
    [self showNewsWithNewsItem:newsItem];
}

#pragma mark - Private Methods

-(void)showNewsWithNewsItem:(QTUMNewsItem*) newsItem {
    
    NSObject<NewsDetailOutput> *newsOutput = [[ControllersFactory sharedInstance] createNewsDetailOutput];
    newsOutput.newsItem = newsItem;
    NewsDetailCellBuilder *cellBuilder = [NewsDetailCellBuilder new];
    newsOutput.cellBuilder = cellBuilder;
//    newsOutput.delegate = self;
    [self.navigationController pushViewController:[newsOutput toPresent] animated:YES];
}


@end
