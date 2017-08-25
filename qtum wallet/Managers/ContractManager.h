;//
//  ContractManager.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 12.04.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Clearable.h"

@class HistoryElement;
@class Contract;

extern NSString *const kTokenDidChange;
extern NSString *const kContractCreationFailed;

@interface ContractManager : NSObject <Managerable, Clearable>

- (NSArray <Contract*>*)allContracts;
- (NSArray <Contract*>*)allTokens;
- (NSArray <Contract*>*)allActiveTokens;
- (void)addNewToken:(Contract*) token;
- (void)updateTokenWithContractAddress:(NSString*) address withAddressBalanceDictionary:(NSDictionary*) addressBalance;
- (void)checkSmartContract:(HistoryElement*) item;
- (void)checkSmartContractPretendents;
- (void)addNewTokenWithContractAddress:(NSString*) contractAddress;
- (void)addSmartContractPretendent:(NSArray*) addresses
                           forKey:(NSString*) key
                     withTemplate:(TemplateModel*)templateModel
              andLocalContractName:(NSString*) localName;

- (BOOL)addNewContractWithContractAddress:(NSString*) contractAddress
                                  withAbi:(NSString*) abiStr
                              andWithName:(NSString*) contractName
                              errorString:(NSString **)errorString;

- (BOOL)addNewTokenWithContractAddress:(NSString*) contractAddress
                               withAbi:(NSString*) abiStr
                           andWithName:(NSString*) contractName
                           errorString:(NSString **)errorString;

- (NSArray<NSDictionary*>*)decodeDataForBackup;
- (BOOL)encodeDataForBacup:(NSArray<NSDictionary*>*) backup withTemplates:(NSArray<TemplateModel*>*) templates;

+ (instancetype)sharedInstance;
- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

@end
