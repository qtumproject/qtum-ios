//
//  NewsCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 02.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "NewsCoordinator.h"
#import "NewsDataSourceAndDelegate.h"
#import "NewsController.h"
#import "NewsCellModel.h"

@interface NewsCoordinator ()

@property (strong, nonatomic) UINavigationController* navigationController;
@property (strong, nonatomic) NewsDataSourceAndDelegate* delegateDataSource;
@property (weak, nonatomic) NewsController* newsController;


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

-(void)start{
    NewsController* controller = (NewsController*)self.navigationController.viewControllers[0];
    controller.delegate = self;
    self.delegateDataSource = [NewsDataSourceAndDelegate new];
    self.delegateDataSource.dataArray = @[];
    controller.delegateDataSource = self.delegateDataSource;
    self.newsController = controller;
}

#pragma mark - NewsCoordinatorDelegate

-(void)refreshTableViewData{
    __weak __typeof(self) weakSelf = self;
    [[ApplicationCoordinator sharedInstance].requestManager getNews:^(id responseObject) {
        [weakSelf parceResponse:responseObject];
        [weakSelf.newsController reloadTableView];
    } andFailureHandler:^(NSError *error, NSString *message) {
        [weakSelf.newsController failedToGetData];
    }];
}

#pragma mark - Private Methods

-(void)parceResponse:(id)response{
    if (!response || ![response isKindOfClass:[NSArray class]]) { return; }
    NSMutableArray* dataArray = @[].mutableCopy;
    for (id item in response) {
        NewsCellModel* object = [[NewsCellModel alloc] initWithDict:item];
        [dataArray addObject:object];
    }
    self.delegateDataSource.dataArray = dataArray;
}


@end
