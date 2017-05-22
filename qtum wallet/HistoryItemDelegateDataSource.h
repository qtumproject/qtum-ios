//
//  HistoryItemDelegateDataSource.h
//  qtum wallet
//
//  Created by Никита Федоренко on 06.04.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HistoryElement;

typedef NS_ENUM(NSInteger, HistoryMode) {
    From,
    To
};

@interface HistoryItemDelegateDataSource : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic)HistoryElement* item;
@property (assign, nonatomic)HistoryMode mode;

@end
