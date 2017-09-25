//
//  NewsOutput.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 21.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NewsOutputDelegate.h"
#import "NewsTableSourceOutput.h"
#import "Presentable.h"

@protocol NewsOutput <NSObject, Presentable>

@property (weak, nonatomic) id<NewsOutputDelegate> delegate;
@property (weak, nonatomic) NSObject<NewsTableSourceOutput> *tableSource;

-(void)reloadTableView;
-(void)failedToGetData;

@end
