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

- (InterfaceInputFormModel*)tokenInterfaceWithTemplate:(NSString*)templateName;
- (NSData*)tokenBitecodeWithTemplate:(NSString*)templateName andParam:(NSDictionary*) args;
- (NSData*)tokenBitecodeWithTemplate:(NSString*)templateName andArray:(NSArray*) args;
- (NSString*)stringHashOfFunction:(AbiinterfaceItem*) fuctionItem;
- (NSData*)hashOfFunction:(AbiinterfaceItem*) fuctionItem;
- (NSData*)hashOfFunction:(AbiinterfaceItem*) fuctionItem appendingParam:(NSArray*) param;


- (AbiinterfaceItem*)tokenStandartTransferMethodInterface;
- (AbiinterfaceItem*)tokenStandartNamePropertyInterface;
- (AbiinterfaceItem*)tokenStandartTotalSupplyPropertyInterface;
- (AbiinterfaceItem*)tokenStandartSymbolPropertyInterface;
- (AbiinterfaceItem*)tokenStandartDecimalPropertyInterface;

+ (instancetype)sharedInstance;

- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

@end
