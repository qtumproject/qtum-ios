//
//  NewsTableSourceDark.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 20.02.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsTableSourceOutput.h"

@interface NewsTableSourceDark : NSObject <NewsTableSourceOutput>

@property (weak, nonatomic) id<NewsTableSourceOutputDelegate> delegate;
@property (copy, nonatomic) NSArray <NewsCellModel*> *dataArray;

@end
