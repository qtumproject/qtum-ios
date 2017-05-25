//
//  ContractManager.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 16.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InterfaceInputFormModel;
@class AbiinterfaceItem;
@class ResultTokenInputsModel;

@interface ContractManager : NSObject

- (InterfaceInputFormModel*)getTokenInterfaceWithTemplate:(NSString*)templateName;
- (NSData*)getTokenBitecodeWithTemplate:(NSString*)templateName andParam:(NSDictionary*) args;
- (NSData*)getTokenBitecodeWithTemplate:(NSString*)templateName andArray:(NSArray*) args;
- (NSString*)getStringHashOfFunction:(AbiinterfaceItem*) fuctionItem andParam:(NSArray<ResultTokenInputsModel*>*)inputs;
- (NSData*)getHashOfFunction:(AbiinterfaceItem*) fuctionItem andParam:(NSArray<ResultTokenInputsModel*>*)inputs;

+ (instancetype)sharedInstance;

- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

@end
