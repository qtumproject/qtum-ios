//
//  NewsTableSourceLight.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 21.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsTableSourceOutput.h"

@interface NewsTableSourceLight : NSObject <NewsTableSourceOutput>

@property (weak, nonatomic) id<NewsTableSourceOutputDelegate> delegate;
@property (copy, nonatomic) NSArray <NewsCellModel*> *dataArray;

@end
