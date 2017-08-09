//
//  QStoreCollectionViewSource.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 26.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QStoreCategoryElement.h"

@protocol QStoreCollectionViewSourceDelegate <NSObject>

- (void)didSelectCollectionCell;

@end

@interface QStoreCollectionViewSource : NSObject <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) id<QStoreCollectionViewSourceDelegate> delegate;
@property (nonatomic) NSArray<QStoreCategoryElement *> *elements;

@end
