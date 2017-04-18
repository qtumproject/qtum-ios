//
//  TokenModel.h
//  qtum wallet
//
//  Created by Никита Федоренко on 18.04.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Walletable.h"
#import "HistoryElement.h"

@interface TokenModel : NSObject <Walletable>

@property (copy, nonatomic) NSString* name;
@property (copy, nonatomic) NSString* balance;
@property (assign, nonatomic) WalletableType type;
@property (strong, nonatomic)NSArray <HistoryElement*>*historyArray;
@property (copy, nonatomic)NSString* activeAddress;
@property (copy, nonatomic)NSString* signature;


@end
