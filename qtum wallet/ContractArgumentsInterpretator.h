//
//  ContractArgumentsInterpretator.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 18.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbiinterfaceItem.h"

@interface ContractArgumentsInterpretator : NSObject

+ (instancetype)sharedInstance;
- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

- (NSData*)contactArgumentsFromDictionary:(NSDictionary*) dict;
- (NSData*)contactArgumentsFromArrayOfValues:(NSArray*) values andArrayOfTypes:(NSArray*) types;
- (NSArray*)аrrayFromContractArguments:(NSData*) data andInterface:(AbiinterfaceItem*) interface;
- (NSData*)contactArgumentFromArrayOfValues:(NSArray*) values andArrayOfTypes:(NSArray<AbiinterfaceInput*>*) inputs;

@end
