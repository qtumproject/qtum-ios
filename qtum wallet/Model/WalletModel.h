//
//  WalletModel.h
//  qtum wallet
//
//  Created by Никита Федоренко on 03.04.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HistoryElement;

@interface WalletModel : NSObject

@property (strong, nonatomic)NSArray <HistoryElement*>*historyArray;
@property (copy, nonatomic)NSString* balance;
@property (copy, nonatomic)NSString* activeAddress;

@end
