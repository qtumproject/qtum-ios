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

#pragma mark - Public Methods

#pragma mark - Private Methods


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
            [token setupWithHashTransaction:key andAddresses:addresses andTokenTemplate:templateModel];
            [self addNewToken:token];
            token.manager = self;
            [[ApplicationCoordinator sharedInstance].notificationManager createLocalNotificationWithString:@"Contract Created" andIdentifire:@"contract_created"];
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
        [token setupWithContractAddresse:contractAddress];
        token.manager = self;
        [self addNewToken:token];
        [[ApplicationCoordinator sharedInstance].notificationManager createLocalNotificationWithString:@"Contract Created" andIdentifire:@"contract_created"];
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

-(void)updateSpendableObject:(Contract*) object {
    __weak __typeof(self)weakSelf = self;
    [[ApplicationCoordinator sharedInstance].requestManager getTokenInfoWithDict:@{@"addressContract" : object.contractAddress} withSuccessHandler:^(id responseObject) {
        object.decimals = responseObject[@"decimals"];
        object.symbol = responseObject[@"symbol"];
        object.name = responseObject[@"name"];
        object.totalSupply = responseObject[@"totalSupply"];
        object.balance = [responseObject[@"totalSupply"] floatValue];
        [weakSelf tokenDidChange:object];
    } andFailureHandler:^(NSError *error, NSString *message) {
        NSLog(@"Error -> %@", error);                            
    }];
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
