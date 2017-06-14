//
//  ContractInterfaceManager.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 16.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@class InterfaceInputFormModel;
@class AbiinterfaceItem;
@class ResultTokenInputsModel;

@interface ContractInterfaceManager : NSObject

- (InterfaceInputFormModel*)getTokenInterfaceWithTemplate:(NSString*)templateName;
- (NSData*)getTokenBitecodeWithTemplate:(NSString*)templateName andParam:(NSDictionary*) args;
- (NSData*)getTokenBitecodeWithTemplate:(NSString*)templateName andArray:(NSArray*) args;
- (NSString*)getStringHashOfFunction:(AbiinterfaceItem*) fuctionItem;
- (NSData*)getHashOfFunction:(AbiinterfaceItem*) fuctionItem;
- (NSData*)getHashOfFunction:(AbiinterfaceItem*) fuctionItem appendingParam:(NSArray*) param;


- (AbiinterfaceItem*)getTokenStandartTransferMethodInterface;
- (AbiinterfaceItem*)getTokenStandartNamePropertyInterface;
- (AbiinterfaceItem*)getTokenStandartTotalSupplyPropertyInterface;
- (AbiinterfaceItem*)getTokenStandartSymbolPropertyInterface;
- (AbiinterfaceItem*)getTokenStandartDecimalPropertyInterface;

+ (instancetype)sharedInstance;

- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

@end
