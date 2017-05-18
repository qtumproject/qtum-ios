//
//  ContractManager.h
//  qtum wallet
//
//  Created by Никита Федоренко on 16.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InterfaceInputFormModel;

@interface ContractManager : NSObject

- (InterfaceInputFormModel*)getStandartTokenIntephase;
- (NSData*)getStandartTokenBitecodeWithParam:(NSDictionary*) args;
- (NSData*)getStandartTokenBitecodeWithArray:(NSArray*) args;

+ (instancetype)sharedInstance;

- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

@end
