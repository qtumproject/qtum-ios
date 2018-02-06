//
//  Log+CoreDataProperties.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 06.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//
//

#import "Log+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Log (CoreDataProperties)

+ (NSFetchRequest<Log *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *address;
@property (nullable, nonatomic, copy) NSString *data;
@property (nullable, nonatomic, retain) NSArray *topics;

@end

NS_ASSUME_NONNULL_END
