//
//  QStoreSearchTableSource.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 28.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QStoreSearchTableSourceDelegate <NSObject>

- (void)didSelectSearchCell;

@end

@interface QStoreSearchTableSource : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<QStoreSearchTableSourceDelegate> delegate;

@end
