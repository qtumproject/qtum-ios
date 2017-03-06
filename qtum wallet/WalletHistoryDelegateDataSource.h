//
//  WalletHistoryDelegateDataSource.h
//  qtum wallet
//
//  Created by Никита Федоренко on 06.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HistoryElement;

@interface WalletHistoryDelegateDataSource : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic)NSArray <HistoryElement*>*historyArray;

@end
