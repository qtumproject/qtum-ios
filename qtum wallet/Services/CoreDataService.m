//
//  CoreDataService.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 01.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "CoreDataService.h"
#import "WalletHistoryEntity+Extension.h"
#import "TransactionReceipt+CoreDataClass.h"
#import "Log+CoreDataProperties.h"
#import "WalletBalanceEntity+Extension.h"
#import "WalletContractHistoryEntity+CoreDataProperties.h"

@interface CoreDataService()

@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;

@end

@implementation CoreDataService

static NSString* storageName = @"TransactionHistory";

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        [self setupInitialState];
        _managedObjectContext = [NSManagedObjectContext MR_context];
    }
    
    return self;
}

-(void)setupInitialState {
    [MagicalRecord setupCoreDataStackWithStoreNamed:storageName];
}

- (WalletHistoryEntity *)createWalletHistoryEntityWith:(HistoryElement*) element {
    
    [self removeAllWalletsHistoryWithTxHash:element.transactionHash];
    
    WalletHistoryEntity* historyEntity =  [WalletHistoryEntity MR_createEntityInContext:self.managedObjectContext];

    historyEntity.address = element.address;
    historyEntity.amountString = element.amountString;
    historyEntity.confirmed = element.confirmed;
    historyEntity.currency = element.currency;
    historyEntity.internal = element.internal;
    historyEntity.fromAddresses = element.fromAddresses;
    historyEntity.toAddresses = element.toAddresses;
    historyEntity.send = element.send;
    historyEntity.feeString = element.fee.stringValue;
    historyEntity.transactionHash = element.transactionHash;
    historyEntity.blockHash = element.blockHash;
    historyEntity.blockNumber = element.blockNumber;
    
    if (element.dateNumber) {
        historyEntity.dateInerval = element.dateNumber.integerValue;
    } else {
        historyEntity.dateInerval = [[NSDate date] timeIntervalSince1970];
    }
    
    NSArray<TransactionReceipt*>* reciepts = [self findAllHistoryReceiptEntityWithTxHash:element.transactionHash];
    
    if (reciepts.count > 0) {
        
        historyEntity.hasReceipt = YES;
        TransactionReceipt* reciept = reciepts.firstObject;
        if (reciept.contractAddress) {
            historyEntity.contracted = YES;
        }
    } else {
        historyEntity.contracted = NO;
        historyEntity.hasReceipt = NO;
    }
    
    return historyEntity;
}

- (WalletContractHistoryEntity *)createWalletContractHistoryEntityWith:(HistoryElement*) element {
    
    [self removeAllWalletContractHistoryWithTxHash:element.transactionHash];
    
    WalletContractHistoryEntity* historyEntity =  [WalletContractHistoryEntity MR_createEntityInContext:self.managedObjectContext];
    
    historyEntity.contractAddress = element.address;
    historyEntity.amountString = element.amountString;
    historyEntity.fromAddresses = element.fromAddresses;
    historyEntity.toAddresses = element.toAddresses;
    historyEntity.transactionHash = element.transactionHash;
    historyEntity.send = element.send;
    historyEntity.internal = element.internal;
    historyEntity.contracted = element.contracted;
    historyEntity.confirmed = element.confirmed;
    historyEntity.currency = element.currency;
    
    if (element.dateNumber) {
        historyEntity.dateInerval = element.dateNumber.integerValue;
    } else {
        historyEntity.dateInerval = [[NSDate date] timeIntervalSince1970];
    }
    
    NSArray<TransactionReceipt*>* reciepts = [self findAllHistoryReceiptEntityWithTxHash:element.transactionHash];

    if (reciepts.count > 0) {

        historyEntity.hasReceipt = YES;

    } else {
        historyEntity.hasReceipt = NO;
    }

    
    return historyEntity;
}

- (TransactionReceipt *)createReceiptEntityWith:(NSArray*) dataArray withTxHash:(NSString*) historyTransactionHash {
    
    
    if (![dataArray isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    if (dataArray.count == 0) {
        TransactionReceipt* receipt =  [TransactionReceipt MR_createEntityInContext:self.managedObjectContext];
        receipt.transactionHash = historyTransactionHash;
        return receipt;
    }
    
    NSDictionary* dataDictionary = dataArray[0];
    
    if (![dataDictionary isKindOfClass:[dataDictionary class]]) {
        return nil;
    }
    
    NSLog(@"%@", dataDictionary);

    id transactionHash = dataDictionary[@"transactionHash"];

    [self removeAllReceiptWithTxHash:transactionHash];
    
    TransactionReceipt* receipt =  [TransactionReceipt MR_createEntityInContext:self.managedObjectContext];

    id blockHash = dataDictionary[@"blockHash"];
    id blockNumber = dataDictionary[@"blockNumber"];
    id contractAddress = dataDictionary[@"contractAddress"];
    id cumulativeGasUsed = dataDictionary[@"cumulativeGasUsed"];
    id from = dataDictionary[@"from"];
    id gasUsed = dataDictionary[@"gasUsed"];
    id to = dataDictionary[@"to"];
    id transactionIndex = dataDictionary[@"transactionIndex"];
    
    if ([blockHash isKindOfClass:[NSString class]]) {
        
        receipt.blockHash = blockHash;
    }
    
    if ([blockNumber isKindOfClass:[NSNumber class]]) {
        
        receipt.blockNumber = [blockNumber integerValue];
    }
    
    if ([contractAddress isKindOfClass:[NSString class]]) {
        
        receipt.contractAddress = contractAddress;
    }
    
    if ([cumulativeGasUsed isKindOfClass:[NSNumber class]]) {
        
        receipt.cumulativeGasUsed = [cumulativeGasUsed integerValue];
    }
    
    if ([from isKindOfClass:[NSString class]]) {
        
        receipt.from = from;
    }
    
    if ([to isKindOfClass:[NSString class]]) {
        
        receipt.to = to;
    }
    
    if ([gasUsed isKindOfClass:[NSNumber class]]) {
        
        receipt.gasUsed = [gasUsed integerValue];
    }
    
    if ([transactionIndex isKindOfClass:[NSNumber class]]) {
        
        receipt.transactionIndex = [transactionIndex integerValue];
    }
    
    if ([transactionHash isKindOfClass:[NSString class]]) {
        
        receipt.transactionHash = transactionHash;
    }
    
    id log = dataDictionary[@"log"];
    
    NSSet <Log *> *logs = [self createLogEntityWith:log];

    [receipt addLogs:logs];
    
    return receipt;
}

- (NSSet <Log *> *)createLogEntityWith:(NSArray*) dataArray {
    
    NSLog(@"%@", dataArray);
    
    if (![dataArray isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableSet <Log *> *logs = [NSMutableSet new];
    
    for (NSDictionary* dataDictionary in dataArray) {
        
        if (![dataDictionary isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        
        Log* log =  [Log MR_createEntityInContext:self.managedObjectContext];
        
        id address = dataDictionary[@"address"];
        id data = dataDictionary[@"data"];
        id topics = dataDictionary[@"topics"];
        
        if ([address isKindOfClass:[NSString class]]) {

            log.address = address;
        }
        
        if ([data isKindOfClass:[NSString class]]) {
            
            log.data = data;
        }
        
        if ([topics isKindOfClass:[NSArray class]]) {
            
            log.topics = topics;
        }
        
        [logs addObject:log];
    }
    
    return logs;
}

- (WalletBalanceEntity*)walletBalanceEntity {
    
    NSArray<WalletBalanceEntity*>* balances = [WalletBalanceEntity MR_findAllInContext:self.managedObjectContext];
    if (balances.count > 0) {
        return balances.firstObject;
    } else {
        return [WalletBalanceEntity MR_createEntityInContext:self.managedObjectContext];;
    }
}

- (void)updateHistoryEntityWithReceiptTxHash:(NSString *_Nonnull) txHash contracted:(BOOL) contracted {
    
    NSArray<WalletHistoryEntity*>* walletHistroy = [self findWalletHistoryEntityWithTxHash:txHash];
    
    for (WalletHistoryEntity* entity in walletHistroy) {
        entity.hasReceipt = YES;
        entity.contracted = contracted;
    }
    
    NSArray<WalletContractHistoryEntity*>* walletContractHistroy = [self findWalletContractHistoryEntityWithTxHash:txHash];
    
    for (WalletContractHistoryEntity* entity in walletContractHistroy) {
        entity.hasReceipt = YES;
        entity.contracted = contracted;
    }
}

-(void)removeAllWalletsHistoryWithTxHash:(NSString*) txHash {
    
    [WalletHistoryEntity MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"transactionHash like %@", txHash] inContext:self.managedObjectContext];
}

-(void)removeAllWalletContractHistoryWithTxHash:(NSString*) txHash {
    
    [WalletContractHistoryEntity MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"transactionHash like %@", txHash] inContext:self.managedObjectContext];
}

-(void)removeAllReceiptWithTxHash:(NSString*) txHash {
    
    [TransactionReceipt MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"transactionHash like %@", txHash] inContext:self.managedObjectContext];
}

- (NSArray<WalletHistoryEntity*>*)findWalletHistoryEntityWithTxHash:(NSString *)txHash {
    
    return [WalletHistoryEntity MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"transactionHash like %@", txHash] inContext:self.managedObjectContext];
}

- (NSArray<WalletContractHistoryEntity*>*)findWalletContractHistoryEntityWithTxHash:(NSString *)txHash {
    
    return [WalletContractHistoryEntity MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"transactionHash like %@", txHash] inContext:self.managedObjectContext];
}

- (TransactionReceipt*_Nullable)findHistoryRecieptEntityWithTxHash:(NSString *_Nonnull)txHash {
    
    NSArray<TransactionReceipt*>* reciepts = [self findAllHistoryReceiptEntityWithTxHash:txHash];
    if (reciepts.count > 0) {
        return reciepts.firstObject;
    } else {
        return nil;
    }
}

- (NSArray<TransactionReceipt*>*)findAllHistoryReceiptEntityWithTxHash:(NSString *)txHash {
    
    return [TransactionReceipt MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"transactionHash like %@", txHash] inContext:self.managedObjectContext];
}

- (void)saveWithcompletion:(void (^)(BOOL contextDidSave, NSError *_Nullable error))complete {

    [self.managedObjectContext MR_saveWithOptions:MRSaveParentContexts completion:^(BOOL contextDidSave, NSError *_Nullable error) {
        if (complete) {
            complete(contextDidSave,error);
        }
    }];
}

-(void)clear {
    
    [WalletHistoryEntity MR_truncateAllInContext:self.managedObjectContext];
    [WalletBalanceEntity MR_truncateAllInContext:self.managedObjectContext];
    [TransactionReceipt MR_truncateAllInContext:self.managedObjectContext];
    
    [self saveWithcompletion:nil];
}

@end
