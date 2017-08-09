//
//  QStoreMainOutput.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreMainOutputDelegate.h"

@class QStoreCategory;

@protocol QStoreMainOutput <NSObject>

@property (weak, nonatomic) id<QStoreMainOutputDelegate> delegate;

- (void)startLoading;
- (void)stopLoading;
- (void)setCategories:(NSArray<QStoreCategory *> *)categories;
- (void)setTag:(NSString *)tag;

@end
