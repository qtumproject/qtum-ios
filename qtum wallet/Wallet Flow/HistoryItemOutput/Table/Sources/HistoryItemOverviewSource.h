//
//  HistoryItemOverviewSource.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 06.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TransactionReceipt;

@protocol HistoryItemOverviewSourceDelegate <NSObject>

- (void)didPressedCopyWithValue:(NSString*) value;

@end

@interface HistoryItemOverviewSource : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) TransactionReceipt *reciept;
@property (strong, nonatomic) id<HistoryElementProtocol> item;
@property (weak, nonatomic) id <HistoryItemOverviewSourceDelegate> delegate;

@end
