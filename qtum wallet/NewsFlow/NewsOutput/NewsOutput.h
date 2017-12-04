//
//  NewsOutput.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 21.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NewsOutputDelegate.h"
#import "Presentable.h"
#import "QTUMNewsItem.h"

@protocol NewsOutput <NSObject, Presentable>

@property (weak, nonatomic) id <NewsOutputDelegate> delegate;
@property (strong, nonatomic) NSArray<QTUMNewsItem *> *news;

- (void)reloadTableView;

- (void)startLoading;

- (void)stopLoadingIfNeeded;

@end
