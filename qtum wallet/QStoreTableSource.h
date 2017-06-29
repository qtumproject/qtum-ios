//
//  QStoreTableSource.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 27.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QStoreTableSourceDelegate <NSObject>

- (void)didSelectCollectionCell;

@end

@interface QStoreTableSource : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<QStoreTableSourceDelegate> delegate;

@end
