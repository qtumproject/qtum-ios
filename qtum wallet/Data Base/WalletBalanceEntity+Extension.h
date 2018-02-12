//
//  WalletBalanceEntity+Extension.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 08.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "WalletBalanceEntity+CoreDataClass.h"

@interface WalletBalanceEntity (Extension)

- (QTUMBigNumber*)balance;
- (QTUMBigNumber*)unconfirmedBalance;
- (NSString*)fullDateString;

@end
