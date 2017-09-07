//
//  NSNumber+Format.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 07.09.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Format)

-(NSString*)shortFormatOfNumberWithPowerOfMinus10:(NSNumber*) power;
-(NSString*)shortFormatOfNumberWithPowerOf10:(NSNumber*) power;

-(NSDecimalNumber*)numberWithPowerOfMinus10:(NSNumber*) power;
-(NSDecimalNumber*)numberWithPowerOf10:(NSNumber*) power;

-(NSString*)stringNumberWithPowerOfMinus10:(NSNumber*) power;
-(NSString*)stringNumberWithPowerOf10:(NSNumber*) power;

-(NSString*)shortFormatOfNumber;

@end
