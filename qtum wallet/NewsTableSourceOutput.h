//
//  NewsTableSourceOutput.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 21.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NewsTableSourceOutputDelegate.h"

@class NewsCellModel;

@protocol NewsTableSourceOutput <NSObject, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) id<NewsTableSourceOutputDelegate> delegate;
@property (copy, nonatomic) NSArray <NewsCellModel*> *dataArray;

@end
