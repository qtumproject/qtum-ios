//
//  BTCBigNumber+Format.h
//  qtum wallet
//
//  Created by Никита Федоренко on 30.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <CoreBitcoin/CoreBitcoin.h>

@interface BTCBigNumber (Format)

-(NSString*)shortFormatOfNumberWithPowerOfMinus10:(BTCBigNumber*) power;
-(NSString*)shortFormatOfNumberWithPowerOf10:(BTCBigNumber*) power;

-(NSDecimalNumber*)numberWithPowerOfMinus10:(BTCBigNumber*) power;
-(NSDecimalNumber*)numberWithPowerOf10:(BTCBigNumber*) power;

-(NSString*)stringNumberWithPowerOfMinus10:(BTCBigNumber*) power;
-(NSString*)stringNumberWithPowerOf10:(BTCBigNumber*) power;

-(NSString*)shortFormatOfNumber;

@end
