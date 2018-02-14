//
//  WalletContractHistoryEntity+CoreDataProperties.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 12.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//
//

#import "WalletContractHistoryEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface WalletContractHistoryEntity (CoreDataProperties)

+ (NSFetchRequest<WalletContractHistoryEntity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *amountString;
@property (nullable, nonatomic, copy) NSString *contractAddress;
@property (nullable, nonatomic, retain) NSObject *fromAddresses;
@property (nullable, nonatomic, retain) NSObject *toAddresses;
@property (nullable, nonatomic, copy) NSString *transactionHash;
@property (nullable, nonatomic, copy) NSString *txTime;
@property (nullable, nonatomic, copy) NSString *decimalString;
@property (nonatomic) int64_t dateInerval;
@property (nonatomic) BOOL hasReceipt;
@property (nullable, nonatomic, copy) NSString *currency;
@property (nonatomic) BOOL confirmed;
@property (nonatomic) BOOL contracted;
@property (nonatomic) BOOL internal;
@property (nonatomic) BOOL send;

@end

NS_ASSUME_NONNULL_END
