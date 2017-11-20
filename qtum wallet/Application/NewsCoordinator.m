//
//  NewsCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 02.03.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NewsCoordinator.h"
#import "NewsOutput.h"
#import "NewsDetailOutput.h"
#import "NewsDetailCellBuilder.h"

@interface NewsCoordinator () <NewsOutputDelegate, NewsDetailOutputDelegate>

@property (strong, nonatomic) UINavigationController *navigationController;
@property (weak, nonatomic) NSObject <NewsOutput> *newsController;
@property (weak, nonatomic) NSObject <NewsDetailOutput> *newsDetailController;


@end

@implementation NewsCoordinator

- (instancetype)initWithNavigationController:(UINavigationController *) navigationController {

	self = [super init];
	if (self) {
		_navigationController = navigationController;
	}
	return self;
}

#pragma mark - Coordinatorable

- (void)start {

	NSObject <NewsOutput> *newsOutput = [SLocator.controllersFactory createNewsOutput];
	newsOutput.delegate = self;
	self.newsController = newsOutput;
	__weak __typeof (self) weakSelf = self;

	NSArray <QTUMNewsItem *> *news = [SLocator.newsDataProvider obtainNewsItems];
	if (news) {
		newsOutput.news = news;
		[newsOutput reloadTableView];
	}

	[SLocator.newsDataProvider getNewsItemsWithCompletion:^(NSArray<QTUMNewsItem *> *news) {
		weakSelf.newsController.news = news;
		[weakSelf.newsController reloadTableView];
	}                                          andFailure:nil];

	[self.navigationController setViewControllers:@[[newsOutput toPresent]]];
}

#pragma mark - NewsOutputDelegate

- (void)refreshTableViewData {

	__weak __typeof (self) weakSelf = self;

	[self.newsController startLoading];
	[SLocator.newsDataProvider getNewsItemsWithCompletion:^(NSArray<QTUMNewsItem *> *news) {
		weakSelf.newsController.news = news;
		[weakSelf.newsController reloadTableView];
		[weakSelf.newsController stopLoadingIfNeeded];
	}                                          andFailure:^{
		[weakSelf.newsController stopLoadingIfNeeded];
	}];
}

- (void)didSelectCellWithNews:(QTUMNewsItem *) newsItem {

	[self showNewsWithNewsItem:newsItem];
}

#pragma mark NewsDetailOutputDelegate

- (void)didBackPressed {
	[SLocator.newsDataProvider cancelAllOperations];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshTagsWithNewsItem:(QTUMNewsItem *) newsItem {

	__weak __typeof (self) weakSelf = self;

	if (!newsItem.tags) {
		[self.newsDetailController startLoading];
		[SLocator.newsDataProvider getTagsFromNews:newsItem withCompletion:^(NSArray<QTUMHTMLTagItem *> *tags) {

			weakSelf.newsDetailController.newsItem = newsItem;
			[weakSelf.newsDetailController stopLoadingIfNeeded];
			[weakSelf.newsDetailController reloadTableView];
		}];
	}
}

#pragma mark - Private Methods

- (void)showNewsWithNewsItem:(QTUMNewsItem *) newsItem {

	NSObject <NewsDetailOutput> *newsOutput = [SLocator.controllersFactory createNewsDetailOutput];
	newsOutput.newsItem = newsItem;
	NewsDetailCellBuilder *cellBuilder = [NewsDetailCellBuilder new];
	newsOutput.cellBuilder = cellBuilder;
	newsOutput.delegate = self;
	self.newsDetailController = newsOutput;
	[self.navigationController pushViewController:[newsOutput toPresent] animated:YES];
}


@end
