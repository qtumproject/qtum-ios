//
//  NewsOutputDelegate.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 21.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//
@class QTUMNewsItem;

@protocol NewsOutputDelegate <NSObject>

@required
-(void)refreshTableViewData;
-(void)didSelectCellWithNews:(QTUMNewsItem*) newsItem;

@end
