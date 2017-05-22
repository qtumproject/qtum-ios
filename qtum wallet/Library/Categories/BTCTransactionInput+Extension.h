//
//  BTCTransactionInput+Extension.h
//  qtum wallet
//
//  Created by Никита Федоренко on 17.04.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <CoreBitcoin/CoreBitcoin.h>

@interface BTCTransactionInput (Extension)

@property (strong, nonatomic) NSString *runTimeAddress;

@end
