//
//  TransactionReceipt+CoreDataProperties.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 06.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//
//

#import "TransactionReceipt+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface TransactionReceipt (CoreDataProperties)

+ (NSFetchRequest<TransactionReceipt *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *blockHash;
@property (nonatomic) int64_t blockNumber;
@property (nullable, nonatomic, copy) NSString *contractAddress;
@property (nonatomic) int64_t cumulativeGasUsed;
@property (nullable, nonatomic, copy) NSString *from;
@property (nonatomic) int64_t gasUsed;
@property (nullable, nonatomic, copy) NSString *to;
@property (nullable, nonatomic, copy) NSString *transactionHash;
@property (nonatomic) int64_t transactionIndex;
@property (nullable, nonatomic, retain) NSSet<Log *> *logs;

@end

@interface TransactionReceipt (CoreDataGeneratedAccessors)

- (void)addLogsObject:(Log *)value;
- (void)removeLogsObject:(Log *)value;
- (void)addLogs:(NSSet<Log *> *)values;
- (void)removeLogs:(NSSet<Log *> *)values;

@end

NS_ASSUME_NONNULL_END
