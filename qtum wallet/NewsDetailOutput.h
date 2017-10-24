//
//  NewsDetailOutput.h
//  qtum wallet
//
//  Created by Никита Федоренко on 20.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Presentable.h"

@class QTUMNewsItem;
@class NewsDetailCellBuilder;

@protocol NewsDetailOutputDelegate <NSObject>

-(void)didBackPressed;

@end

@protocol NewsDetailOutput <Presentable>

@property (weak, nonatomic) id <NewsDetailOutputDelegate> delegate;
@property (strong, nonatomic) QTUMNewsItem* newsItem;
@property (strong, nonatomic) NewsDetailCellBuilder* cellBuilder;

-(void)reloadTableView;
-(void)failedToGetData;

@end
