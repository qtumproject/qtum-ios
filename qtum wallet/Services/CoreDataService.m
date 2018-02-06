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

@interface CoreDataService()

@property (strong, nonatomic) NSManagedObjectContext* managedObjectContext;

@end

@implementation CoreDataService

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        [self setupInitialState];
        _managedObjectContext = [NSManagedObjectContext MR_context];
    }
    
    return self;
}

-(void)setupInitialState {
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"TransactionHistory"];
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
    historyEntity.transactionHash = element.transactionHash;
    
    
    if (element.dateNumber) {
        historyEntity.dateInerval = element.dateNumber.integerValue;
    } else {
        historyEntity.dateInerval = [[NSDate date] timeIntervalSince1970];
    }
    
    NSArray<TransactionReceipt*>* reciepts = [self findHistoryReceiptEntityWithTxHash:element.transactionHash];
    
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
        
        id address = dataDictionary[@"transactionIndex"];
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

-(void)removeAllWalletsHistoryWithTxHash:(NSString*) txHash {
    
    NSArray<WalletHistoryEntity*>* sameHistories = [self findWalletHistoryEntityWithTxHash:txHash];
    
    for (WalletHistoryEntity* entity in sameHistories) {
        [entity MR_deleteEntityInContext:self.managedObjectContext];
    }
}

-(void)removeAllReceiptWithTxHash:(NSString*) txHash {
    
    NSArray<TransactionReceipt*>* sameHistories = [self findHistoryReceiptEntityWithTxHash:txHash];
    
    for (WalletHistoryEntity* entity in sameHistories) {
        [entity MR_deleteEntityInContext:self.managedObjectContext];
    }
}

- (NSArray<WalletHistoryEntity*>*)findWalletHistoryEntityWithTxHash:(NSString *)txHash {
    
    return [WalletHistoryEntity MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"transactionHash like %@", txHash] inContext:self.managedObjectContext];
}

- (NSArray<TransactionReceipt*>*)findHistoryReceiptEntityWithTxHash:(NSString *)txHash {
    
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
    [TransactionReceipt MR_truncateAllInContext:self.managedObjectContext];
    [self saveWithcompletion:nil];
}

@end
