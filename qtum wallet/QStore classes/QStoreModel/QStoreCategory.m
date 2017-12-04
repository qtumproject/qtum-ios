//
//  QStoreCategory.m
//  qtum wallet
//
//  Created by Vladimir Sharaev on 27.09.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QStoreCategory.h"
#import "QStoreContractElement.h"

@interface QStoreCategory ()

@property (nonatomic) NSString *identifier;
@property (nonatomic) NSString *name;
@property (nonatomic) NSNumber *fullCountactCount;
@property (nonatomic) NSArray<QStoreContractElement *> *elements;

@end

@implementation QStoreCategory

- (instancetype)initWithIdentifier:(NSString *) identifier
							  name:(NSString *) name
							 count:(NSNumber *) count {

	self = [super init];
	if (self) {
		_identifier = identifier;
		_name = name;
		_elements = [NSArray<QStoreContractElement *> new];
		_fullCountactCount = count;
	}
	return self;
}

- (void)parseElementsFromJSONArray:(NSArray *) array {
	NSMutableArray *mutArray = [NSMutableArray new];
	for (NSDictionary *dictionary in array) {
		QStoreContractElement *element = [QStoreContractElement createFromCategoryDictionary:dictionary];
		if (element) {
			[mutArray addObject:element];
		}
	}
	self.elements = [NSArray arrayWithArray:mutArray];
}

@end
