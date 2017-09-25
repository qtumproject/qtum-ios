//
//  QStoreListTableSource.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 28.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol QStoreListTableSourceDelegate <NSObject>

- (void)didSelectCell:(NSIndexPath *)indexPath;

@end

@interface QStoreListTableSource : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<QStoreListTableSourceDelegate> delegate;
@property (nonatomic) NSArray *array;


@end
