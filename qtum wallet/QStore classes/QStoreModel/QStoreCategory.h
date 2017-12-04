//
//  QStoreCategory.h
//  qtum wallet
//
//  Created by Vladimir Sharaev on 27.09.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QStoreContractElement;

@interface QStoreCategory : NSObject

@property (nonatomic, readonly) NSString *identifier;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSNumber *fullCountactCount;
@property (nonatomic, readonly) NSArray<QStoreContractElement *> *elements;

- (instancetype)initWithIdentifier:(NSString *) identifier
							  name:(NSString *) name
							 count:(NSNumber *) count;

- (void)parseElementsFromJSONArray:(NSArray *) array;

@end
