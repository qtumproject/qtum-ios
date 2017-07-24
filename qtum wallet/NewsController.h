//
//  NewsController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 07.02.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsOutput.h"

@interface NewsController : BaseViewController <NewsOutput>

@property (weak, nonatomic) id<NewsOutputDelegate> delegate;
@property (weak, nonatomic) NSObject<NewsTableSourceOutput> *tableSource;

@end
