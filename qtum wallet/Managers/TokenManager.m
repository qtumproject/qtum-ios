//
//  TokenManager.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 12.04.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "TokenManager.h"
#import "HistoryElement.h"
#import "FXKeychain.h"
#import "Contract.h"
#import "ContractManager.h"
#import "ContractArgumentsInterpretator.h"
#import "NSData+Extension.h"

NSString const *kTokenKeys = @"qtum_token_tokens_keys";
NSString *const kTokenDidChange = @"kTokenDidChange";

static NSString* kSmartContractPretendentsKey = @"smartContractPretendentsKey";
static NSString* kTemplateModel = @"kTemplateModel";
static NSString* kAddresses = @"kAddress";


@interface TokenManager () <TokenDelegate>

@property (strong, nonatomic) NSMutableDictionary* smartContractPretendents;
@property (nonatomic, strong) NSMutableArray<Contract*> *contracts;

@end

@implementation TokenManager

+ (instancetype)sharedInstance {
    
    static TokenManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] initUniqueInstance];
    });
    return instance;
}

- (instancetype)initUniqueInstance {
    
    self = [super init];
    if (self != nil) {
        [self load];
    }
    return self;
}

#pragma mark - Lazy Getters

-(NSMutableDictionary*)smartContractPretendents{
    
    if (!_smartContractPretendents) {
        _smartContractPretendents = @{}.mutableCopy;
    }
    return _smartContractPretendents;
}

- (NSMutableArray<Contract*>*)contracts {
    
    if (!_contracts) {
        _contracts = @[].mutableCopy;
    }
    return _contracts;
}

#pragma mark - Keychain Methods

- (BOOL)save {
    
    BOOL isSavedTokens = [[FXKeychain defaultKeychain] setObject:self.contracts forKey:kTokenKeys];
    
    BOOL isSavedPretendents = [[FXKeychain defaultKeychain] setObject:[self.smartContractPretendents copy] forKey:kSmartContractPretendentsKey];
    return isSavedTokens && isSavedPretendents;
}

- (void)load {
    
    [NSKeyedUnarchiver setClass:[Contract class] forClassName:@"Token"];
    NSMutableArray *savedTokens = [[[FXKeychain defaultKeychain] objectForKey:kTokenKeys] mutableCopy];
    
    for (Contract *token in savedTokens) {
        token.delegate = self;
        token.manager = self;
        [token loadToMemory];
    }
    self.smartContractPretendents = [[[FXKeychain defaultKeychain] objectForKey:kSmartContractPretendentsKey] mutableCopy];
    self.contracts = savedTokens;
}


#pragma mark - Private Methods

#pragma mark - Public Methods

- (NSArray <Contract*>*)getAllTokens {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"templateModel.type == %i",TokenType];
    return [self.contracts filteredArrayUsingPredicate:predicate];
}

- (NSArray <Contract*>*)getAllActiveTokens {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"templateModel.type == %i && isActive == YES",TokenType];
    return [self.contracts filteredArrayUsingPredicate:predicate];
}

- (NSArray <Contract*>*)getAllContracts {
    
    return self.contracts;
}

- (void)addNewToken:(Contract*) token{
    
    token.delegate = self;
    [self.contracts addObject:token];
    [[ApplicationCoordinator sharedInstance].requestManager startObservingForToken:token withHandler:nil];
    [self tokenDidChange:token];
}

- (void)updateTokenWithAddress:(NSString*) address withNewBalance:(NSString*) balance{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contractAddress == %@",address];
    NSArray *filteredArray = [self.contracts filteredArrayUsingPredicate:predicate];
    Contract* token = filteredArray[0];
    if (token) {
        token.balance = [balance floatValue];
        [self tokenDidChange:token];
    }
}

- (void)updateTokenWithContractAddress:(NSString*) address withAddressBalanceDictionary:(NSDictionary*) addressBalance {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contractAddress == %@",address];
    NSArray *filteredArray = [self.contracts filteredArrayUsingPredicate:predicate];
    Contract* token = filteredArray[0];
    if (token) {
        NSMutableDictionary* newAddressBalance = token.addressBalanceDictionary ? [token.addressBalanceDictionary mutableCopy] : @{}.mutableCopy;
        for (NSDictionary* dict in addressBalance[@"balances"]) {
            
            NSString* addressKey = dict[@"address"];
            [newAddressBalance setObject:@([dict[@"balance"] floatValue]) forKey:addressKey];
        }
        token.addressBalanceDictionary = [newAddressBalance copy];
        [self tokenDidChange:token];
    }
}

- (void)removeAllTokens{
    
    [self.contracts removeAllObjects];
}

- (void)removeAllPretendents{
    
    [self.smartContractPretendents removeAllObjects];
}

-(void)addSmartContractPretendent:(NSArray*) addresses forKey:(NSString*) key withTemplate:(TemplateModel*)templateModel{
    
    [self.smartContractPretendents setObject:@{kAddresses : addresses,
                                               kTemplateModel : templateModel} forKey:key];
    [self save];
}

-(void)deleteSmartContractPretendentWithKey:(NSString*) key{
    
    [self.smartContractPretendents removeObjectForKey:key];
}

-(void)updateSmartContractPretendent:(BTCTransaction*) transaction{
    //TODO update Token Transaction
}

-(void)checkSmartContract:(HistoryElement*) item {
    
    if (item.confirmed && item.isSmartContractCreater) {
        NSString* key = item.txHash;
        NSDictionary* tokenInfo = [self.smartContractPretendents objectForKey:key];
        NSArray* addresses = tokenInfo[kAddresses];
        TemplateModel* templateModel = (TemplateModel*)tokenInfo[kTemplateModel];
        
        if (tokenInfo) {
            Contract* token = [Contract new];
            NSMutableData* hashData = [[NSData reverseData:[NSString dataFromHexString:key]] mutableCopy];
            uint32_t vinIndex = 0;
            [hashData appendBytes:&vinIndex length:1];
            hashData = [[hashData BTCHash160] mutableCopy];
            token.contractCreationAddressAddress = addresses.firstObject;
            token.adresses =  [[[WalletManager sharedInstance] getHashTableOfKeys] allKeys];
            token.contractAddress = [NSString hexadecimalString:hashData];
            token.localName = [token.contractAddress substringToIndex:6];
            token.templateModel = templateModel;
            token.creationDate = [NSDate date];
            token.isActive = YES;
            //[token setupWithHashTransaction:key andAddresses:addresses andTokenTemplate:templateModel];
            [self addNewToken:token];
            token.manager = self;
            [[ApplicationCoordinator sharedInstance].notificationManager createLocalNotificationWithString:@"Contract Created" andIdentifire:@"contract_created"];
            [self updateSpendableObject:token];
            [self deleteSmartContractPretendentWithKey:key];
            [self save];
        }
    }
}

-(void)addNewTokenWithContractAddress:(NSString*) contractAddress {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contractAddress == %@",contractAddress];
    NSArray *filteredArray = [self.contracts filteredArrayUsingPredicate:predicate];
    
    if (!filteredArray.count && contractAddress) {
        Contract* token = [Contract new];
        token.contractAddress = contractAddress;
        token.creationDate = [NSDate date];
        token.localName = [token.contractAddress substringToIndex:6];
        token.adresses = [[[WalletManager sharedInstance] getHashTableOfKeys] allKeys];
        //[token setupWithContractAddresse:contractAddress];
        token.manager = self;
        [self addNewToken:token];
        [[ApplicationCoordinator sharedInstance].notificationManager createLocalNotificationWithString:@"Contract Created" andIdentifire:@"contract_created"];
        [self updateSpendableObject:token];
        [self save];
        [self tokenDidChange:nil];
    }
}

-(BOOL)addNewContractWithContractAddress:(NSString*) contractAddress withAbi:(NSString*) abiStr andWithName:(NSString*) contractName {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contractAddress == %@",contractAddress];
    NSArray *filteredArray = [self.contracts filteredArrayUsingPredicate:predicate];
    
    if (!filteredArray.count && contractAddress) {
        
        Contract* contract = [Contract new];
        contract.contractAddress = contractAddress;
        contract.creationDate = [NSDate date];
        contract.localName = contractName;
        contract.adresses = [[[WalletManager sharedInstance] getHashTableOfKeys] allKeys];
        contract.manager = self;
        
        TemplateModel* template = [[ContractManager sharedInstance] createNewContractTemplateWithAbi:abiStr contractAddress:contractAddress andName:contractName];
        
        if (template) {
            
            contract.templateModel = template;
            [self addNewToken:contract];
            [[ApplicationCoordinator sharedInstance].notificationManager createLocalNotificationWithString:@"Contract Created" andIdentifire:@"contract_created"];
            [self updateSpendableObject:contract];
            [self save];
            [self tokenDidChange:nil];
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)addNewTokenWithContractAddress:(NSString*) contractAddress
                               withAbi:(NSString*) abiStr
                           andWithName:(NSString*) contractName {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"contractAddress == %@",contractAddress];
    NSArray *filteredArray = [self.getAllTokens filteredArrayUsingPredicate:predicate];
    
    if (!filteredArray.count && contractAddress) {
        
        Contract* contract = [Contract new];
        contract.contractAddress = contractAddress;
        contract.creationDate = [NSDate date];
        contract.localName = contractName;
        contract.adresses = [[[WalletManager sharedInstance] getHashTableOfKeys] allKeys];
        contract.manager = self;
        contract.isActive = YES;
        
        TemplateModel* template = [[ContractManager sharedInstance] createNewTokenTemplateWithAbi:abiStr contractAddress:contractAddress andName:contractName];
        
        if (template) {
            
            contract.templateModel = template;
            [self addNewToken:contract];
            [[ApplicationCoordinator sharedInstance].notificationManager createLocalNotificationWithString:@"Contract Created" andIdentifire:@"contract_created"];
            [self updateSpendableObject:contract];
            [self save];
            [self tokenDidChange:nil];
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - TokenDelegate

- (void)tokenDidChange:(id)token {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kTokenDidChange object:nil userInfo:nil];
    [self save];
}

#pragma mark - Managerable

-(void)updateSpendableObject:(Contract*) token {
    
    __weak __typeof(self)weakSelf = self;
    
    if (token.templateModel.type == TokenType) {
        
        AbiinterfaceItem* nameProperty = [[ContractManager sharedInstance] getTokenStandartNamePropertyInterface];
        AbiinterfaceItem* totalSupplyProperty = [[ContractManager sharedInstance] getTokenStandartTotalSupplyPropertyInterface];
        AbiinterfaceItem* symbolProperty = [[ContractManager sharedInstance] getTokenStandartSymbolPropertyInterface];
        AbiinterfaceItem* decimalProperty = [[ContractManager sharedInstance] getTokenStandartDecimalPropertyInterface];
        
        NSString* hashFuctionName = [[ContractManager sharedInstance] getStringHashOfFunction:nameProperty];
        NSString* hashFuctionTotalSupply = [[ContractManager sharedInstance] getStringHashOfFunction:totalSupplyProperty];
        NSString* hashFuctionSymbol = [[ContractManager sharedInstance] getStringHashOfFunction:symbolProperty];
        NSString* hashFuctionDecimal = [[ContractManager sharedInstance] getStringHashOfFunction:decimalProperty];
        
        [[ApplicationCoordinator sharedInstance].requestManager callFunctionToContractAddress:token.contractAddress withHashes:@[hashFuctionName, hashFuctionTotalSupply, hashFuctionSymbol, hashFuctionDecimal] withHandler:^(id responseObject) {
            
            if (![responseObject isKindOfClass:[NSError class]] && [responseObject[@"items"] isKindOfClass:[NSArray class]]) {
                
                for (NSDictionary* item in responseObject[@"items"]) {
                    NSString* hash = item[@"hash"];
                    NSString* output = item[@"output"];
                    
                    if ([hash isEqualToString:hashFuctionName.uppercaseString]) {
                        NSArray* array = [ContractArgumentsInterpretator аrrayFromContractArguments:[NSString dataFromHexString:output] andInterface:nameProperty];
                        token.name = array[0];
                    } else if ([hash isEqualToString:hashFuctionTotalSupply.uppercaseString]) {
                        
                        NSArray* array = [ContractArgumentsInterpretator аrrayFromContractArguments:[NSString dataFromHexString:output] andInterface:totalSupplyProperty];
                        token.totalSupply = array[0];
                        
                    } else if ([hash isEqualToString:hashFuctionSymbol.uppercaseString]) {
                        
                        NSArray* array = [ContractArgumentsInterpretator аrrayFromContractArguments:[NSString dataFromHexString:output] andInterface:symbolProperty];
                        token.symbol = array[0];
                    } else if ([hash isEqualToString:hashFuctionDecimal.uppercaseString]) {
                        
                        NSArray* array = [ContractArgumentsInterpretator аrrayFromContractArguments:[NSString dataFromHexString:output] andInterface:decimalProperty];
                        token.decimals = array[0];
                    }
                    
                }
                [weakSelf tokenDidChange:token];
            }
        }];
    }
}

-(void)updateBalanceOfSpendableObject:(id <Spendable>) object withHandler:(void (^)(BOOL))complete {
    [complete copy];
    complete(NO);
    NSLog(@"complete ->%@",complete);
}

-(void)updateHistoryOfSpendableObject:(id <Spendable>) object withHandler:(void (^)(BOOL))complete andPage:(NSInteger) page{
    [complete copy];
    complete(NO);
    object.historyStorage.pageIndex = page;
    NSLog(@"complete ->%@",complete);
}

-(void)startObservingForSpendable:(id <Spendable>) spendable {
    [[ApplicationCoordinator sharedInstance].requestManager startObservingForToken:spendable withHandler:nil];
}

-(void)stopObservingForSpendable:(id <Spendable>) spendable {
    [[ApplicationCoordinator sharedInstance].requestManager stopObservingForToken:spendable];
}

-(void)startObservingForAllSpendable {
    
    NSArray <Contract*>* activeContract = [self getAllActiveTokens];
    for (Contract* token in activeContract) {
        [[ApplicationCoordinator sharedInstance].requestManager startObservingForToken:token withHandler:nil];
    }
}

-(void)stopObservingForAllSpendable {
    NSArray <Contract*>* activeContract = [self getAllActiveTokens];
    for (Contract* token in activeContract) {
        [[ApplicationCoordinator sharedInstance].requestManager stopObservingForToken:token];
    }
}

-(void)loadSpendableObjects {
    [self load];
}

-(void)saveSpendableObjects {
    [self save];
}

-(void)updateSpendableWithObject:(id) updateObject{
    
}


-(void)updateSpendablesBalansesWithObject:(id) updateObject{
    
}

-(void)updateSpendablesHistoriesWithObject:(id) updateObject{
    
}

-(void)spendableDidChange:(id <Spendable>) object{
    [self tokenDidChange:object];
}

-(void)clear{
    
    [self removeAllTokens];
    [self removeAllPretendents];
    [self save];
}

@end
