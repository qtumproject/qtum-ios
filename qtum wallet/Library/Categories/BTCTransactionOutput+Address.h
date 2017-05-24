//
//  BTCTransactionOutput+Address.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.04.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <CoreBitcoin/CoreBitcoin.h>

@interface BTCTransactionOutput (Address)

@property (strong, nonatomic) NSString *runTimeAddress;

@end
