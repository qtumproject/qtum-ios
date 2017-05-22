//
//  ContractArgumentsInterpretator.h
//  qtum wallet
//
//  Created by Никита Федоренко on 18.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContractArgumentsInterpretator : NSObject

+(NSData*)contactArgumentsFromDictionary:(NSDictionary*) dict;
+(NSData*)contactArgumentsFromArray:(NSArray*) array;

@end
