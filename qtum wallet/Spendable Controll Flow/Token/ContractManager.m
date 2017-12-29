//
//  ContractManager.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 12.04.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NSData+Extension.h"
#import "SocketManager.h"
#import "InterfaceInputFormModel.h"
#import "WalletManagerRequestAdapter.h"
#import "ContractManagerRequestAdapter.h"

NSString *const kTokenKeys = @"qtum_token_tokens_keys";
NSString *const kTokenDidChange = @"kTokenDidChange";
NSString *const kContractCreationFailed = @"kContractCreationFailed";

NSString *const kSmartContractPretendentsKey = @"smartContractPretendentsKey";
NSString *const kFailedContractPretendentsKey = @"failedContractPretendentsKey";
NSString *const kTemplateModel = @"kTemplateModel";
NSString *const kAddresses = @"kAddress";
NSString *const kLocalContractName = @"kLocalContractName";


@interface ContractManager () <TokenDelegate>

@property (strong, nonatomic) NSMutableDictionary *smartContractPretendents;
@property (strong, nonatomic) NSMutableDictionary *failedContractPretendents;
@property (nonatomic, strong) NSMutableArray<Contract *> *contracts;
@property (assign, nonatomic) BOOL observingForSpendableFailed;
@property (assign, nonatomic) BOOL observingForSpendableStopped;
@property (assign, nonatomic) BOOL haveAuthUser;

@property (strong, nonatomic) ContractManagerRequestAdapter *requestAdapter;

@end

@implementation ContractManager

- (instancetype)init {

	self = [super init];
	if (self != nil) {
		[self load];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector (didContinieObservingForSpendable)
													 name:kSocketDidConnect object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector (didForceStopObservingForSpendable)
													 name:kSocketDidDisconnect object:nil];
        
        _requestAdapter = [ContractManagerRequestAdapter new];
	}
	return self;
}

- (void)dealloc {

	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Observing

- (void)didContinieObservingForSpendable {

	if (self.observingForSpendableFailed && !self.observingForSpendableStopped) {
		[self startObservingForAllSpendable];
	}
	self.observingForSpendableFailed = NO;
}

- (void)didForceStopObservingForSpendable {

	self.observingForSpendableFailed = YES;
}

#pragma mark - Lazy Getters

- (NSMutableDictionary *)smartContractPretendents {

	if (!_smartContractPretendents) {
		_smartContractPretendents = @{}.mutableCopy;
	}
	return _smartContractPretendents;
}

- (NSMutableDictionary *)failedContractPretendents {
    
    if (!_failedContractPretendents) {
        _failedContractPretendents = @{}.mutableCopy;
    }
    return _failedContractPretendents;
}

- (NSMutableArray<Contract *> *)contracts {

	if (!_contracts) {
		_contracts = @[].mutableCopy;
	}
	return _contracts;
}

#pragma mark - Keychain Methods

- (BOOL)save {

	BOOL isSavedTokens = [SLocator.keychainService setObject:self.contracts forKey:kTokenKeys];

	BOOL isSavedPretendents = [SLocator.keychainService setObject:[self.smartContractPretendents copy] forKey:kSmartContractPretendentsKey];
    
    BOOL isSavedFailedPretendents = [SLocator.keychainService setObject:[self.failedContractPretendents copy] forKey:kFailedContractPretendentsKey];

	return isSavedTokens && isSavedPretendents && isSavedFailedPretendents;
}

- (void)load {

	[NSKeyedUnarchiver setClass:[Contract class] forClassName:@"Token"];
	NSMutableArray *savedTokens = [[SLocator.keychainService objectForKey:kTokenKeys] mutableCopy];

	for (Contract *token in savedTokens) {
		token.delegate = self;
		token.manager = self;
		[token loadToMemory];
	}
	self.smartContractPretendents = [[SLocator.keychainService objectForKey:kSmartContractPretendentsKey] mutableCopy];
    
    self.failedContractPretendents = [[SLocator.keychainService objectForKey:kFailedContractPretendentsKey] mutableCopy];

	self.contracts = savedTokens;
}


#pragma mark - Private Methods

- (BOOL)validateContractAddress:(NSString *) contractAddress {

	NSString *addresRegex = @"[0-9a-f]{40,}";
	NSPredicate *addressPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", addresRegex];
	return [addressPredicate evaluateWithObject:contractAddress];
}

-(NSMutableDictionary <NSString *, QTUMBigNumber *> *)emptyTokenAddressBalancesDict {
    
    NSArray* addresses = SLocator.walletManager.wallet.addressesInRightOrder;
    NSMutableDictionary <NSString *, QTUMBigNumber *> * emptyTokensBalances = @{}.mutableCopy;
    
    for (int i = 0; i < addresses.count; i++) {
        QTUMBigNumber* zeroValue = [QTUMBigNumber decimalWithInteger:0];
        [emptyTokensBalances setObject:zeroValue forKey:addresses[i]];
    }
    
    return emptyTokensBalances;
}

#pragma mark - Public Methods

- (void)removeContract:(Contract *) contract {

	if (!contract) {
		return;
	}

	[self.contracts removeObject:contract];
	[SLocator.requestManager stopObservingForToken:contract];
	[self tokenDidChange:nil];
}

- (void)removeContractPretendentWithTxHash:(NSString *) txHash {

	[self.smartContractPretendents removeObjectForKey:txHash];
	[self save];
}

- (void)removeFailedContractPretendentWithTxHash:(NSString *) txHash {
    
    [self.failedContractPretendents removeObjectForKey:txHash];
    [self save];
}

- (NSArray <Contract *> *)allTokens {

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"templateModel.type == %i", TokenType];
	return [self.contracts filteredArrayUsingPredicate:predicate];
}

- (NSArray <Contract *> *)allActiveTokens {

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"templateModel.type == %i && isActive == YES", TokenType];
	return [self.contracts filteredArrayUsingPredicate:predicate];
}

- (NSArray <Contract *> *)allContracts {

	return self.contracts;
}

- (NSDictionary *)smartContractPretendentsCopy {
	return [self.smartContractPretendents copy];
}

- (NSDictionary *)failedContractPretendentsCopy {
    return [self.failedContractPretendents copy];
}

- (void)addNewContract:(Contract *) token {

	if (!token) {
		return;
	}

	token.delegate = self;
	[self.contracts addObject:token];
	[SLocator.requestManager startObservingForToken:token withHandler:nil];
	[self tokenDidChange:token];
}

- (void)updateTokenWithContractAddress:(NSString *) address withAddressBalanceDictionary:(NSDictionary *) addressBalance {

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contractAddress == %@", address];
	NSArray *filteredArray = [self.contracts filteredArrayUsingPredicate:predicate];
	Contract *token = filteredArray.count ? filteredArray[0] : nil;
	if (token) {

        NSMutableDictionary *newAddressBalance = token.addressBalanceDictionary ? [token.addressBalanceDictionary mutableCopy] : [self emptyTokenAddressBalancesDict];
		for (NSDictionary *dict in addressBalance[@"balances"]) {

			NSString *addressKey = dict[@"address"];
			NSString *balance = dict[@"balance"];

			if (balance) {
				if ([balance isKindOfClass:[NSNumber class]]) {
					newAddressBalance[addressKey] = [[QTUMBigNumber alloc] initWithString:[(NSNumber *)balance stringValue]];
				} else if ([balance isKindOfClass:[NSString class]]) {
					newAddressBalance[addressKey] = [[QTUMBigNumber alloc] initWithString:balance];
				}
			}
		}
		token.addressBalanceDictionary = [newAddressBalance copy];
		[self tokenDidChange:token];
	}
}

- (void)removeAllTokens {

	[self.contracts removeAllObjects];
}

- (void)removeAllFailedPretendents {
    
    [self.failedContractPretendents removeAllObjects];
}

- (void)removeAllPretendents {

	[self.smartContractPretendents removeAllObjects];
}

- (void)addSmartContractPretendent:(NSArray *) addresses
							forKey:(NSString *) key
					  withTemplate:(TemplateModel *) templateModel
			  andLocalContractName:(NSString *) localName {


	if (localName) {

		self.smartContractPretendents[key] = @{kAddresses: addresses,
				kTemplateModel: templateModel,
				kLocalContractName: localName};
	} else {
		self.smartContractPretendents[key] = @{kAddresses: addresses,
				kTemplateModel: templateModel};
	}

	[self save];
}

- (void)addFailedContractPretendent:(NSDictionary*) failedPretendent forKey:(NSString*) key {
    
    [self.failedContractPretendents setObject:failedPretendent forKey:key];
}

- (void)deleteSmartContractPretendentWithKey:(NSString *) key {

	[self.smartContractPretendents removeObjectForKey:key];
}

- (void)updateSmartContractPretendent:(BTCTransaction *) transaction {
}

- (void)checkSmartContractPretendents {

	for (NSString *txHash in self.smartContractPretendents) {

		[SLocator.walletManager.requestAdapter updateHistoryElementWithTxHash:txHash withSuccessHandler:^(HistoryElement *historyItem) {

			if (historyItem) {
				[self checkSmartContract:historyItem];
			}

		}                                                   andFailureHandler:^(NSError *error, NSString *message) {

			DLog(@"Invalid hisory response");
		}];
	}
}

- (void)checkSmartContract:(HistoryElement *) item {

	if ([[SLocator.walletManager hashTableOfKeys] allKeys].count == 0) {
		return;
	}

    NSString *key = item.txHash;
    NSDictionary *tokenInfo = key ? self.smartContractPretendents[key] : @{};
    
	if (item.confirmed && item.isSmartContractCreater && [self.smartContractPretendents objectForKey:key]) {


		NSArray *addresses = tokenInfo[kAddresses];
		NSString *localContractName = tokenInfo[kLocalContractName];

		TemplateModel *templateModel = (TemplateModel *)tokenInfo[kTemplateModel];
		NSMutableData *hashData = [[NSData reverseData:[NSString dataFromHexString:key]] mutableCopy];
		NSString *contractAddress = [NSString hexadecimalString:hashData];

		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contractAddress == %@", contractAddress];
		NSArray *filteredArray = [self.contracts filteredArrayUsingPredicate:predicate];

		if (tokenInfo && !filteredArray.count) {
			Contract *contract = [Contract new];
			uint32_t vinIndex = 0;
			[hashData appendBytes:&vinIndex length:4];
			hashData = [[hashData BTCHash160] mutableCopy];
			contract.contractCreationAddressAddress = addresses.firstObject;
			contract.adresses = [[SLocator.walletManager hashTableOfKeys] allKeys];
			contract.contractAddress = [NSString hexadecimalString:hashData];
			contract.localName = (localContractName && [localContractName stringByReplacingOccurrencesOfString:@" " withString:@""].length > 0) ? localContractName : [contract.contractAddress substringToIndex:15];
			contract.templateModel = templateModel;
            if (contract.templateModel.type == TokenType) {
                contract.addressBalanceDictionary = [self emptyTokenAddressBalancesDict];
            }
			contract.creationDate = [NSDate date];
			contract.isActive = YES;
			[self addNewContract:contract];
			contract.manager = self;
			[SLocator.notificationManager createLocalNotificationWithString:NSLocalizedString(@"Contract Created", nil) andIdentifire:@"contract_created"];
			[self updateSpendableObject:contract];
			[self deleteSmartContractPretendentWithKey:key];
			[self save];
		}
	} else if (item.confirmed && [self.smartContractPretendents objectForKey:key]) {
        
        [self addFailedContractPretendent:self.smartContractPretendents[key] forKey:key];
        [self deleteSmartContractPretendentWithKey:key];
        [self save];
		[[NSNotificationCenter defaultCenter] postNotificationName:kContractCreationFailed object:nil];
	}
}

- (void)addNewTokenWithContractAddress:(NSString *) contractAddress {

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contractAddress == %@", contractAddress];
	NSArray *filteredArray = [self.contracts filteredArrayUsingPredicate:predicate];

	if (!filteredArray.count && contractAddress) {

		Contract *token = [Contract new];
		token.contractAddress = contractAddress;
		token.creationDate = [NSDate date];
        
        token.addressBalanceDictionary = [self emptyTokenAddressBalancesDict];
		token.localName = [token.contractAddress substringToIndex:contractAddress.length > 15 ? 15 : contractAddress.length];
		token.adresses = [[SLocator.walletManager hashTableOfKeys] allKeys];
		token.manager = self;
        TemplateModel *template = [SLocator.templateManager standartTokenTemplate];

        if (template) {
            token.templateModel = template;
            [self addNewContract:token];
            [SLocator.notificationManager createLocalNotificationWithString:NSLocalizedString(@"Contract Created", nil) andIdentifire:@"contract_created"];
            [self updateSpendableObject:token];
            [self tokenDidChange:nil];
        }
	}
}

- (BOOL)addNewContractWithContractAddress:(NSString *) contractAddress
								  withAbi:(NSString *) abiStr
							  andWithName:(NSString *) contractName
							  errorString:(NSString **) errorString {

	if (!contractName || contractName.length == 0) {
		*errorString = NSLocalizedString(@"Invalid Contract Name", nil);
		return NO;
	}

	if (![self validateContractAddress:contractAddress]) {
		*errorString = NSLocalizedString(@"Invalid Contract Address", nil);
		return NO;
	}

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contractAddress == %@", contractAddress];
	NSArray *filteredArray = [self.contracts filteredArrayUsingPredicate:predicate];
	if (filteredArray.count > 0) {
		*errorString = NSLocalizedString(@"Contract with same address already exists", nil);
		return NO;
	}

	Contract *contract = [Contract new];
	contract.contractAddress = contractAddress;
	contract.creationDate = [NSDate date];
	contract.localName = contractName;
	contract.adresses = [[SLocator.walletManager hashTableOfKeys] allKeys];
	contract.manager = self;

	TemplateModel *template = [SLocator.templateManager createNewContractTemplateWithAbi:abiStr contractAddress:contractAddress andName:contractName];

	if (template) {

		contract.templateModel = template;
		[self addNewContract:contract];
		[SLocator.notificationManager createLocalNotificationWithString:NSLocalizedString(@"Contract Created", nil) andIdentifire:@"contract_created"];
		[self updateSpendableObject:contract];
		[self tokenDidChange:nil];
		return YES;
	}

	*errorString = NSLocalizedString(@"Something went wrong", nil);
	return NO;
}

- (BOOL)addNewTokenWithContractAddress:(NSString *) contractAddress
						   andWithName:(NSString *) contractName
						   errorString:(NSString **) errorString {

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contractAddress == %@", contractAddress];
	NSArray *filteredArray = [self.allTokens filteredArrayUsingPredicate:predicate];
    
	if (filteredArray.count > 0) {
		*errorString = NSLocalizedString(@"Token with same address already exists", nil);
		return NO;
	}

	Contract *token = [Contract new];
	token.contractAddress = contractAddress;
	token.creationDate = [NSDate date];
    token.localName = contractName.length > 0 ? contractName : [contractAddress substringToIndex:contractAddress.length > 15 ? 15 : contractAddress.length];
	token.adresses = [[SLocator.walletManager hashTableOfKeys] allKeys];
    token.addressBalanceDictionary = [self emptyTokenAddressBalancesDict];
	token.manager = self;
	token.isActive = YES;

	TemplateModel *template = [SLocator.templateManager standartTokenTemplate];

	if (template) {
		token.templateModel = template;
		[self addNewContract:token];
		[SLocator.notificationManager createLocalNotificationWithString:NSLocalizedString(@"Token Created", nil) andIdentifire:@"contract_created"];
		[self updateSpendableObject:token];
		[self tokenDidChange:nil];

		return YES;
	}

	*errorString = NSLocalizedString(@"Something went wrong", nil);
	return NO;
}

#pragma mark - TokenDelegate

- (void)tokenDidChange:(id) token {

	[[NSNotificationCenter defaultCenter] postNotificationName:kTokenDidChange object:nil userInfo:nil];
	[self save];
}

#pragma mark - Managerable

- (void)updateSpendableObject:(Contract *) token {

    [self updateBalanceOfSpendableObject:token withHandler:nil];
}

- (void)updateBalanceOfSpendableObject:(Contract*) token withHandler:(void (^)(BOOL)) complete {
    

    __weak __typeof (self) weakSelf = self;
    
    if (token.templateModel.type == TokenType) {
        
        AbiinterfaceItem *nameProperty = [SLocator.contractInterfaceManager tokenStandartNamePropertyInterface];
        AbiinterfaceItem *totalSupplyProperty = [SLocator.contractInterfaceManager tokenStandartTotalSupplyPropertyInterface];
        AbiinterfaceItem *symbolProperty = [SLocator.contractInterfaceManager tokenStandartSymbolPropertyInterface];
        AbiinterfaceItem *decimalProperty = [SLocator.contractInterfaceManager tokenStandartDecimalPropertyInterface];
        
        NSString *hashFuctionName = [SLocator.contractInterfaceManager stringHashOfFunction:nameProperty];
        NSString *hashFuctionTotalSupply = [SLocator.contractInterfaceManager stringHashOfFunction:totalSupplyProperty];
        NSString *hashFuctionSymbol = [SLocator.contractInterfaceManager stringHashOfFunction:symbolProperty];
        NSString *hashFuctionDecimal = [SLocator.contractInterfaceManager stringHashOfFunction:decimalProperty];
        
        [SLocator.requestManager callFunctionToContractAddress:token.contractAddress
                                                  frommAddress:nil
                                                    withHashes:@[hashFuctionName, hashFuctionTotalSupply, hashFuctionSymbol, hashFuctionDecimal] withHandler:^(id responseObject) {
                                                        
                                                        if (![responseObject isKindOfClass:[NSError class]] && [responseObject[@"items"] isKindOfClass:[NSArray class]]) {
                                                            
                                                            for (NSDictionary *item in responseObject[@"items"]) {
                                                                NSString *hash = item[@"hash"];
                                                                NSString *output = item[@"output"];
                                                                
                                                                if ([hash isEqualToString:hashFuctionName.uppercaseString]) {
                                                                    NSArray *array = [SLocator.contractArgumentsInterpretator аrrayFromContractArguments:[NSString dataFromHexString:output] andInterface:nameProperty];
                                                                    if (array.count > 0) {
                                                                        token.name = array[0];
                                                                    }
                                                                } else if ([hash isEqualToString:hashFuctionTotalSupply.uppercaseString]) {
                                                                    
                                                                    NSArray *array = [SLocator.contractArgumentsInterpretator аrrayFromContractArguments:[NSString dataFromHexString:output] andInterface:totalSupplyProperty];
                                                                    if (array.count > 0) {
                                                                        token.totalSupply = array[0];
                                                                    }
                                                                    
                                                                } else if ([hash isEqualToString:hashFuctionSymbol.uppercaseString]) {
                                                                    
                                                                    NSArray *array = [SLocator.contractArgumentsInterpretator аrrayFromContractArguments:[NSString dataFromHexString:output] andInterface:symbolProperty];
                                                                    if (array.count > 0) {
                                                                        token.symbol = array[0];
                                                                    }
                                                                } else if ([hash isEqualToString:hashFuctionDecimal.uppercaseString]) {
                                                                    
                                                                    NSArray *array = [SLocator.contractArgumentsInterpretator аrrayFromContractArguments:[NSString dataFromHexString:output] andInterface:decimalProperty];
                                                                    if (array.count > 0) {
                                                                        token.decimals = array[0];
                                                                    }
                                                                }
                                                                
                                                                if (complete) {
                                                                    complete(YES);
                                                                }
                                                            }
                                                        } else {
                                                            if (complete) {
                                                                complete(NO);
                                                            }
                                                        }
                                                        
                                                        [weakSelf tokenDidChange:token];
                                                    }];
    }
}

- (void)updateHistoryOfSpendableObject:(id <Spendable>) object withHandler:(void (^)(BOOL)) complete andPage:(NSInteger) page {
    
    static NSInteger batch = 25;
    NSArray* allkeysAddresses = SLocator.walletManager.wallet.allKeysAdreeses;
    
    NSDictionary* param = @{@"limit": @(batch),
                            @"offset": @(page * batch),
                            @"addresses[]" : allkeysAddresses
                            };
    
    [self.requestAdapter getHistoryForTokenAddress:object.mainAddress
                                          andParam:param
                                             token:object
                                withSuccessHandler:^(NSArray <id <HistoryElementProtocol>> *history) {
        if (page > object.historyStorage.pageIndex) {
            [object.historyStorage addHistoryElements:history];
        } else {
            [object.historyStorage setHistory:history];
        }
        object.historyStorage.pageIndex = page;
        if (complete) {
            complete (YES);
        }
    } andFailureHandler:^(NSError *error, NSString *message) {
        if (complete) {
            complete (NO);
        }
    }];
	DLog(@"complete ->%@", complete);
}

- (void)startObservingForSpendable:(id <Spendable>) spendable {

	self.observingForSpendableStopped = NO;
	[SLocator.requestManager startObservingForToken:spendable withHandler:nil];
}

- (void)stopObservingForSpendable:(id <Spendable>) spendable {

	self.observingForSpendableStopped = YES;
	[SLocator.requestManager stopObservingForToken:spendable];
}

- (void)startObservingForAllSpendable {

	NSArray <Contract *> *activeContract = [self allActiveTokens];
	for (Contract *token in activeContract) {
		[SLocator.requestManager startObservingForToken:token withHandler:nil];
	}
}

- (void)stopObservingForAllSpendable {
	NSArray <Contract *> *activeContract = [self allActiveTokens];
	for (Contract *token in activeContract) {
		[SLocator.requestManager stopObservingForToken:token];
	}
}

- (void)loadSpendableObjects {
	[self load];
}

- (void)saveSpendableObjects {
	[self save];
}

- (void)updateSpendableWithObject:(id) updateObject { }

- (void)updateSpendablesBalansesWithObject:(id) updateObject { }

- (void)updateSpendablesHistoriesWithObject:(id) updateObject { }

- (void)spendableDidChange:(id <Spendable>) object {
	[self tokenDidChange:object];
}

- (void)historyOfSpendableDidChange:(id<Spendable>)object { }


- (void)clear {

	[self removeAllTokens];
	[self removeAllPretendents];
    [self removeAllFailedPretendents];
	[self save];
}

#pragma mark - Backup

static NSString *kPublishDate = @"publish_date";
static NSString *kNameKey = @"name";
static NSString *kContractAddressKey = @"contract_address";
static NSString *kContractCreationAddressKey = @"contract_creation_address";
static NSString *kIsActiveKey = @"is_active";
static NSString *kTypeKey = @"type";
static NSString *kTemplateKey = @"template";

- (NSArray<NSDictionary *> *)decodeDataForBackup {

	NSMutableArray *backupArray = @[].mutableCopy;

	for (int i = 0; i < self.contracts.count; i++) {
		NSMutableDictionary *backupItem = @{}.mutableCopy;
		Contract *contract = self.contracts[i];
		backupItem[kPublishDate] = contract.creationFormattedDateString;
		backupItem[kNameKey] = contract.localName;
		backupItem[kContractAddressKey] = contract.contractAddress;
		backupItem[kContractCreationAddressKey] = contract.contractCreationAddressAddress ? : @"";
		backupItem[kIsActiveKey] = @(contract.isActive);
		backupItem[kTypeKey] = contract.templateModel.templateTypeStringForBackup;
		backupItem[kTemplateKey] = contract.templateModel.uuid;
		[backupArray addObject:backupItem];
	}

	return backupArray.copy;
}

- (BOOL)encodeDataForBacup:(NSArray<NSDictionary *> *) backup withTemplates:(NSArray<TemplateModel *> *) templates {

	BOOL processedWithoutError = YES;

	for (NSDictionary *contractDict in backup) {

		Contract *contract = [Contract new];
		contract.localName = contractDict[kNameKey];
		contract.contractAddress = contractDict[kContractAddressKey];
		contract.contractCreationAddressAddress = contractDict[kContractCreationAddressKey];
		contract.creationDate = [NSDate date];
		contract.isActive = [contractDict[kIsActiveKey] boolValue];

		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid == %@", contractDict[kTemplateKey]];
		NSArray *filteredTemplates = [templates filteredArrayUsingPredicate:predicate];
		NSPredicate *predicateForAddress = [NSPredicate predicateWithFormat:@"contractAddress == %@", contract.contractAddress];
		NSArray *filteredContractAddressArray = [self.contracts filteredArrayUsingPredicate:predicateForAddress];

		if (filteredTemplates.count > 0 && !filteredContractAddressArray.count) {
			contract.templateModel = filteredTemplates[0];
			[self addNewContract:contract];
			[SLocator.notificationManager createLocalNotificationWithString:NSLocalizedString(@"Contract Created", nil) andIdentifire:@"contract_created"];
			[self updateSpendableObject:contract];
			[self save];
			[self tokenDidChange:nil];
		} else {
			processedWithoutError = NO;
		}
	}

	return processedWithoutError;
}

@end
