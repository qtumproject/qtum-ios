//
//  CoreDataService.m
//  qtum wallet
//
//  Created by Fedorenko Nikita on 01.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "CoreDataService.h"
#import "WalletHistoryEntity+Extension.h"

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
    
    [self removeAllWalletsHistoryWithTxHash:element.txHash];
    
    WalletHistoryEntity* historyEntity =  [WalletHistoryEntity MR_createEntityInContext:self.managedObjectContext];

    historyEntity.address = element.address;
    historyEntity.amountString = element.amountString;
    historyEntity.confirmed = element.confirmed;
    historyEntity.currency = element.currency;
    //self.dateNumber = element.dateNumber.integerValue;
    historyEntity.send = element.send;
    historyEntity.txHash = element.txHash;
    
    return historyEntity;
}

-(void)removeAllWalletsHistoryWithTxHash:(NSString*) txHash {
    
    NSArray<WalletHistoryEntity*>* sameHistories = [self findWalletHistoryEntityWithTxHash:txHash];
    
    for (WalletHistoryEntity* entity in sameHistories) {
        [entity MR_deleteEntityInContext:self.managedObjectContext];
    }
}

- (NSArray<WalletHistoryEntity*>*)findWalletHistoryEntityWithTxHash:(NSString *)txHash {
    
    return [WalletHistoryEntity MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"txHash like %@", txHash] inContext:self.managedObjectContext];
}

- (void)saveWithcompletion:(void (^)(BOOL contextDidSave, NSError *_Nullable error))complete {

    [self.managedObjectContext MR_saveWithOptions:MRSaveParentContexts completion:^(BOOL contextDidSave, NSError *_Nullable error) {
        complete(contextDidSave,error);
    }];
}

@end
