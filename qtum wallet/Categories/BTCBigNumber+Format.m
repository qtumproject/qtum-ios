//
//  BTCBigNumber+Format.m
//  qtum wallet
//
//  Created by Никита Федоренко on 30.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "BTCBigNumber+Format.h"

@implementation BTCBigNumber (Format)

-(NSString*)shortFormatOfNumberWithPowerOfMinus10:(BTCBigNumber*) power {
    
    return [self.mutableCopy exp:power].decimalString;
}

-(NSString*)shortFormatOfNumberWithPowerOf10:(BTCBigNumber*) power {
    
    return [self.mutableCopy exp:power].decimalString;
}

-(BTCBigNumber*)numberWithPowerOfMinus10:(BTCBigNumber*) power {
    return [self.mutableCopy exp:power mod:[[BTCBigNumber alloc] initWithInt32:-1]];
}

-(BTCBigNumber*)numberWithPowerOf10:(BTCBigNumber*) power {
    return [self.mutableCopy exp:power];
}

-(NSString*)stringNumberWithPowerOfMinus10:(BTCBigNumber*) power {
    
    return [self numberWithPowerOfMinus10:power].stringValue;
}

-(NSString*)stringNumberWithPowerOf10:(BTCBigNumber*) power {
    return [self numberWithPowerOf10:power].stringValue;
}

-(NSString*)shortFormatOfNumber {
    return self.decimalString;
}

@end
