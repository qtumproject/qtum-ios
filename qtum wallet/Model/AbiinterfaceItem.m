//
//  AbiIntephaseItem.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

@interface AbiinterfaceItem ()

@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) BOOL constant;
@property (assign, nonatomic) BOOL payable;
@property (assign, nonatomic) AbiItemType type;
@property (strong, nonatomic) NSArray <AbiinterfaceInput *> *inputs;
@property (strong, nonatomic) NSArray <AbiInterfaceOutput *> *outputs;

@end

@implementation AbiinterfaceItem

- (instancetype)initWithObject:(id) object {

	self = [super init];
	if (self) {
		[self setUpWithObject:object];
	}
	return self;
}

- (void)setUpWithObject:(id) object {

	if ([object isKindOfClass:[NSDictionary class]]) {
		_name = [object[@"name"] isKindOfClass:[NSNull class]] ? nil : object[@"name"];
		_constant = [object[@"constant"] isKindOfClass:[NSNull class]] ? : [object[@"constant"] boolValue];
		_payable = [object[@"payable"] isKindOfClass:[NSNull class]] ? : [object[@"payable"] boolValue];
		_type = [self determineTipe:object[@"type"]];
		_inputs = [self setupInputs:object[@"inputs"]];
		_outputs = [self setupOutputs:object[@"outputs"]];
	}
}

- (AbiItemType)determineTipe:(NSString *) typeString {

	if ([typeString isEqualToString:@"function"]) {
		return Function;
	} else if ([typeString isEqualToString:@"constructor"]) {
		return Constructor;
	} else if ([typeString isEqualToString:@"fallback"]) {
		return Fallback;
	}

	return Undefined;
}

- (NSArray <AbiinterfaceInput *> *)setupInputs:(NSDictionary *) inputs {

	NSMutableArray *entries = @[].mutableCopy;
	for (NSDictionary *item in inputs) {
		AbiinterfaceInput *inputItem = [[AbiinterfaceInput alloc] initWithObject:item];
		[entries addObject:inputItem];
	}

	return entries;
}

- (NSArray <AbiInterfaceOutput *> *)setupOutputs:(NSDictionary *) outputs {

	NSMutableArray *entries = @[].mutableCopy;
	for (NSDictionary *item in outputs) {
		AbiinterfaceInput *outputItem = [[AbiinterfaceInput alloc] initWithObject:item];
		[entries addObject:outputItem];
	}

	return entries;
}

#pragma mark - Equality

- (BOOL)isEqualToInterfaceItem:(AbiinterfaceItem *) aInterfaceItem {

	if (!aInterfaceItem) {
		return NO;
	}

	BOOL haveEqualInterfaceNames = (!self.name && !aInterfaceItem.name) || [self.name isEqualToString:aInterfaceItem.name];
	BOOL haveEqualConstant = self.constant == aInterfaceItem.constant;
	BOOL haveEqualType = self.type == aInterfaceItem.type;
	BOOL haveEqualPayable = self.payable == aInterfaceItem.payable;

	BOOL haveEqualInputs = (!self.inputs && !aInterfaceItem.inputs) || [self.inputs isEqualToArray:aInterfaceItem.inputs];
	BOOL haveEqualOutputs = (!self.outputs && !aInterfaceItem.outputs) || [self.outputs isEqualToArray:aInterfaceItem.outputs];

	return haveEqualInterfaceNames && haveEqualConstant && haveEqualType && haveEqualPayable && haveEqualInputs && haveEqualOutputs;
}

- (BOOL)isEqual:(id) anObject {

	if (self == anObject) {
		return YES;
	}

	if (![anObject isKindOfClass:[AbiinterfaceItem class]]) {
		return NO;
	}

	return [self isEqualToInterfaceItem:(AbiinterfaceItem *)anObject];
}

- (NSUInteger)hash {

	return [self.name hash] ^ self.constant ^ self.payable ^ self.type ^ [self.inputs hash] ^ [self.outputs hash];
}

@end
