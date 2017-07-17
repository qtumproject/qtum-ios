;//
//  ContractManager.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 12.04.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HistoryElement;
@class Contract;

extern NSString *const kTokenDidChange;

@interface ContractManager : NSObject <Managerable>

- (NSArray <Contract*>*)allContracts;
- (NSArray <Contract*>*)allTokens;
- (NSArray <Contract*>*)allActiveTokens;
- (void)addNewToken:(Contract*) token;
- (void)updateTokenWithAddress:(NSString*) address withNewBalance:(NSString*) balance;
- (void)updateTokenWithContractAddress:(NSString*) address withAddressBalanceDictionary:(NSDictionary*) addressBalance;
- (void)checkSmartContract:(HistoryElement*) item;
- (void)addNewTokenWithContractAddress:(NSString*) contractAddress;
- (void)addSmartContractPretendent:(NSArray*) addresses forKey:(NSString*) key withTemplate:(TemplateModel*)templateModel;
- (BOOL)addNewContractWithContractAddress:(NSString*) contractAddress
                                  withAbi:(NSString*) abiStr
                              andWithName:(NSString*) contractName;
- (BOOL)addNewTokenWithContractAddress:(NSString*) contractAddress
                                  withAbi:(NSString*) abiStr
                              andWithName:(NSString*) contractName;

- (NSArray<NSDictionary*>*)decodeDataForBackup;
- (BOOL)encodeDataForBacup:(NSArray<NSDictionary*>*) backup withTemplates:(NSArray<TemplateModel*>*) templates;

+ (instancetype)sharedInstance;
- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

@end
