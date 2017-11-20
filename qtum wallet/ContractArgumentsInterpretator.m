//
//  ContractArgumentsInterpretator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 18.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NSData+Extension.h"
#import "NSString+AbiRegex.h"


@interface ContractArgumentsInterpretator ()

@end

@implementation ContractArgumentsInterpretator

NSInteger standardParameterBatch = 32;

- (NSData *)contactArgumentsFromDictionary:(NSDictionary *) dict {
	return nil;
}

- (NSData *)contactArgumentsFromArrayOfValues:(NSArray<NSString *> *) values andArrayOfTypes:(NSArray *) types {

	NSMutableData *args = [NSMutableData new];
	NSMutableArray *staticDataArray = @[].mutableCopy;
	NSMutableArray *dynamicDataArray = @[].mutableCopy;
	NSNumber *offset = @(32 * values.count);

	//decode data
	for (int i = 0; i < values.count; i++) {

		id <AbiParameterProtocol> type = types[i];

		//decode arrays
		if ([type isKindOfClass:[AbiParameterTypeArray class]]) {

			//dynamic elementary array
			if ([type isKindOfClass:[AbiParameterTypeDynamicElementaryArray class]]) {

				[self convertElementaryDynamicArrayWithStaticStack:staticDataArray
												   andDynamicStack:dynamicDataArray
														  withType:type
														 andOffset:&offset
														  withData:values[i]];
			}

				//fixed elementary array
			else if ([type isKindOfClass:[AbiParameterTypeFixedElementaryArray class]]) {

				[self convertElementaryStaticArrayWithStaticStack:staticDataArray
												  andDynamicStack:dynamicDataArray
														 withType:type
														andOffset:&offset
														 withData:values[i]];
			} else if ([type isKindOfClass:[AbiParameterTypeDynamicArrayString class]]) {

				[self convertDynamicStringArrayWithStaticStack:staticDataArray
											   andDynamicStack:dynamicDataArray
													  withType:type
													 andOffset:&offset
													  withData:values[i]];
			}
		}

			//decode primitive types
		else if ([type isKindOfClass:[AbiParameterPrimitiveType class]]) {

			[self convertElementaryTypesWith:staticDataArray withType:type andOffset:&offset withData:values[i]];
		}

			//decode addresses
		else if ([type isKindOfClass:[AbiParameterTypeAddress class]]) {

			[self convertAddressesWith:staticDataArray withType:type andOffset:&offset withData:values[i]];
		}

			//decode strings
		else if ([type isKindOfClass:[AbiParameterTypeString class]]) {

			[self convertStringsWithStaticStack:staticDataArray andDynamicStack:dynamicDataArray withType:type andOffset:&offset withData:values[i]];
		}

			//decode bytes
		else if ([type isKindOfClass:[AbiParameterTypeBytes class]]) {

			[self convertBytesWithStaticStack:staticDataArray andDynamicStack:dynamicDataArray withType:type andOffset:&offset withData:values[i]];
		}
	}


	//combination of data
	for (int i = 0; i < staticDataArray.count; i++) {
		[args appendData:staticDataArray[i]];
	}

	for (int i = 0; i < dynamicDataArray.count; i++) {
		[args appendData:dynamicDataArray[i]];
	}

	return args;
}

- (void)convertElementaryTypesWith:(NSMutableArray *) staticDataArray
						  withType:(id <AbiParameterProtocol>) type
						 andOffset:(NSNumber **) offset
						  withData:(NSString *) data {

	if (![data isKindOfClass:[NSString class]]) {
		return;//bail if wrong data
	}

	if ([type isKindOfClass:[AbiParameterTypeUInt class]]) {

		BTCBigNumber *bigNumber = [[BTCBigNumber alloc] initWithDecimalString:data];
		[staticDataArray addObject:[bigNumber unsignedBigEndian] ? : [self emptyData32bit]];

	} else if ([type isKindOfClass:[AbiParameterTypeBool class]]) {

		NSInteger param;
		if ([data isEqualToString:@"false"]) {
			param = 0;
		} else if ([data isEqualToString:@"true"]) {
			param = 1;
		} else {
			param = [data integerValue];
		}

		[staticDataArray addObject:[NSData reverseData:[self data32BitsFromInt:param withSize:1]] ? : [self emptyData32bit]];
	} else if ([type isKindOfClass:[AbiParameterTypeAddress class]]) {


		NSData *hexDataFromBase58 = [data dataFromBase58];

		if (hexDataFromBase58.length == 25) {
			hexDataFromBase58 = [[hexDataFromBase58 subdataWithRange:NSMakeRange (1, 20)] mutableCopy];
		}

		hexDataFromBase58 = [self appendDataToEnd32bytesData:hexDataFromBase58];

		[staticDataArray addObject:hexDataFromBase58 ? : [self emptyData32bit]];

	} else if ([type isKindOfClass:[AbiParameterTypeFixedBytes class]]) {

		AbiParameterTypeFixedBytes *bytesType = (AbiParameterTypeFixedBytes *)type;
		NSMutableData *dataBytes = [[data dataUsingEncoding:NSASCIIStringEncoding] mutableCopy];

		if (dataBytes.length > bytesType.size) {
			dataBytes = [[dataBytes subdataWithRange:NSMakeRange (0, bytesType.size)] mutableCopy];
		}

		[dataBytes increaseLengthBy:standardParameterBatch - dataBytes.length];

		[staticDataArray addObject:[dataBytes copy] ? : [self emptyData32bit]];
	}
}

- (void)convertAddressesWith:(NSMutableArray *) staticDataArray
					withType:(id <AbiParameterProtocol>) type
				   andOffset:(NSNumber **) offset
					withData:(NSString *) data {

	if (![data isKindOfClass:[NSString class]]) {
		return;//bail if wrong data
	}

	NSData *hexDataFromBase58 = [data dataFromBase58];

	if (hexDataFromBase58.length == 25) {
		hexDataFromBase58 = [[hexDataFromBase58 subdataWithRange:NSMakeRange (1, 20)] mutableCopy];
	}

	hexDataFromBase58 = [self appendDataToEnd32bytesData:hexDataFromBase58];

	[staticDataArray addObject:hexDataFromBase58 ? : [self emptyData32bit]];
}

- (void)convertStringsWithStaticStack:(NSMutableArray *) staticDataArray
					  andDynamicStack:(NSMutableArray *) dynamicDataStack
							 withType:(id <AbiParameterProtocol>) type
							andOffset:(NSNumber **) offset
							 withData:(NSString *) string {

	if (![string isKindOfClass:[NSString class]]) {
		return;//bail if wrong data
	}

	//adding offset
	[staticDataArray addObject:[NSData reverseData:[self uint256DataFromInt:[*offset integerValue]]]];

	//adding dynamic data in dynamic stack
	NSInteger length = [string dataUsingEncoding:NSUTF8StringEncoding].length;
	[dynamicDataStack addObject:[NSData reverseData:[self uint256DataFromInt:length]]];

	NSData *stringData = [self dataMultiple32bitFromString:string];
	[dynamicDataStack addObject:stringData ? : [self emptyData32bit]];

	//inc offset
	*offset = @([*offset integerValue] + stringData.length + standardParameterBatch);
}

- (void)convertElementaryDynamicArrayWithStaticStack:(NSMutableArray *) staticDataArray
									 andDynamicStack:(NSMutableArray *) dynamicDataStack
											withType:(id <AbiParameterProtocol>) type
										   andOffset:(NSNumber **) offset
											withData:(NSString *) data {

	if (![data isKindOfClass:[NSString class]]) {
		return;//bail if wrong data
	}

	//adding offset
	[staticDataArray addObject:[NSData reverseData:[self uint256DataFromInt:[*offset integerValue]]]];

	//adding dynamic data in dynamic stack
	NSArray *arrayElements = [data dynamicArrayElementsFromParameter];
	NSInteger length = arrayElements.count;

	[dynamicDataStack addObject:[NSData reverseData:[self uint256DataFromInt:length]]];


	if ([type isKindOfClass:[AbiParameterTypeDynamicArrayUInt class]]) {

		for (int i = 0; i < arrayElements.count; i++) {

			NSString *element = arrayElements[i];
			BTCBigNumber *bigNumber = [[BTCBigNumber alloc] initWithDecimalString:element];
			[dynamicDataStack addObject:[bigNumber unsignedBigEndian] ? : [self emptyData32bit]];
		}

	} else if ([type isKindOfClass:[AbiParameterTypeDynamicArrayInt class]]) {

		for (int i = 0; i < arrayElements.count; i++) {

			NSString *element = arrayElements[i];
			BTCBigNumber *bigNumber = [[BTCBigNumber alloc] initWithDecimalString:element];
			[dynamicDataStack addObject:[bigNumber unsignedBigEndian] ? : [self emptyData32bit]];
		}

	} else if ([type isKindOfClass:[AbiParameterTypeDynamicArrayBool class]]) {

		for (int i = 0; i < arrayElements.count; i++) {

			NSInteger param;
			NSString *element = arrayElements[i];
			if ([element isEqualToString:@"false"]) {
				param = 0;
			} else if ([element isEqualToString:@"true"]) {
				param = 1;
			} else {
				param = [element integerValue];
			}

			[dynamicDataStack addObject:[NSData reverseData:[self uint256DataFromInt:param]] ? : [self emptyData32bit]];
		}

	} else if ([type isKindOfClass:[AbiParameterTypeDynamicArrayAddress class]]) {

		for (int i = 0; i < arrayElements.count; i++) {

			NSString *element = arrayElements[i];
			NSData *hexDataFromBase58 = [element dataFromBase58];

			if (hexDataFromBase58.length == 25) {
				hexDataFromBase58 = [[hexDataFromBase58 subdataWithRange:NSMakeRange (1, 20)] mutableCopy];
			}

			hexDataFromBase58 = [self appendDataToEnd32bytesData:hexDataFromBase58];

			[dynamicDataStack addObject:hexDataFromBase58 ? : [self emptyData32bit]];
		}

	} else if ([type isKindOfClass:[AbiParameterTypeDynamicArrayFixedBytes class]]) {


		for (int i = 0; i < arrayElements.count; i++) {

			AbiParameterTypeDynamicArrayFixedBytes *bytesType = (AbiParameterTypeDynamicArrayFixedBytes *)type;
			NSString *element = arrayElements[i];
			NSMutableData *dataBytes = [[element dataUsingEncoding:NSASCIIStringEncoding] mutableCopy];

			if (dataBytes.length > bytesType.elementSize) {
				dataBytes = [[dataBytes subdataWithRange:NSMakeRange (0, bytesType.elementSize)] mutableCopy];
			}

			[dataBytes increaseLengthBy:standardParameterBatch - dataBytes.length];

			[dynamicDataStack addObject:[dataBytes copy] ? : [self emptyData32bit]];
		}

	}

	//inc offset
	*offset = @([*offset integerValue] + (length * standardParameterBatch) + standardParameterBatch);
}

- (void)convertElementaryStaticArrayWithStaticStack:(NSMutableArray *) staticDataArray
									andDynamicStack:(NSMutableArray *) dynamicDataStack
										   withType:(AbiParameterTypeFixedElementaryArray *) aType
										  andOffset:(NSNumber **) offset
										   withData:(NSString *) data {

	if (![data isKindOfClass:[NSString class]]) {
		return;//bail if wrong data
	}

	//adding offset
	[staticDataArray addObject:[NSData reverseData:[self uint256DataFromInt:[*offset integerValue]]]];

	//adding dynamic data in dynamic stack
	NSArray *arrayElements = [data dynamicArrayElementsFromParameter];
	NSInteger length = aType.size;

	[dynamicDataStack addObject:[NSData reverseData:[self uint256DataFromInt:length]]];

	if ([aType isKindOfClass:[AbiParameterTypeFixedArrayUInt class]]) {

		AbiParameterTypeFixedArrayUInt *type = (AbiParameterTypeFixedArrayUInt *)aType;

		for (int i = 0; i < type.size; i++) {

			NSString *element = arrayElements[i];
			BTCBigNumber *bigNumber = [[BTCBigNumber alloc] initWithDecimalString:element];
			[dynamicDataStack addObject:[bigNumber unsignedBigEndian] ? : [self emptyData32bit]];
		}

	} else if ([aType isKindOfClass:[AbiParameterTypeFixedArrayInt class]]) {

		AbiParameterTypeFixedArrayInt *type = (AbiParameterTypeFixedArrayInt *)aType;

		for (int i = 0; i < type.size; i++) {

			NSString *element = arrayElements[i];
			BTCBigNumber *bigNumber = [[BTCBigNumber alloc] initWithDecimalString:element];
			[dynamicDataStack addObject:[bigNumber unsignedBigEndian] ? : [self emptyData32bit]];
		}

	} else if ([aType isKindOfClass:[AbiParameterTypeFixedArrayBool class]]) {

		AbiParameterTypeFixedArrayBool *type = (AbiParameterTypeFixedArrayBool *)aType;

		for (int i = 0; i < type.size; i++) {

			NSInteger param;
			NSString *element = arrayElements[i];
			if ([element isEqualToString:@"false"]) {
				param = 0;
			} else if ([element isEqualToString:@"true"]) {
				param = 1;
			} else {
				param = [element integerValue];
			}

			[dynamicDataStack addObject:[NSData reverseData:[self uint256DataFromInt:param]] ? : [self emptyData32bit]];
		}

	} else if ([aType isKindOfClass:[AbiParameterTypeFixedArrayAddress class]]) {

		AbiParameterTypeFixedArrayAddress *type = (AbiParameterTypeFixedArrayAddress *)aType;

		for (int i = 0; i < type.size; i++) {

			NSString *element = arrayElements[i];
			NSData *hexDataFromBase58 = [element dataFromBase58];

			if (hexDataFromBase58.length == 25) {
				hexDataFromBase58 = [[hexDataFromBase58 subdataWithRange:NSMakeRange (1, 20)] mutableCopy];
			}

			hexDataFromBase58 = [self appendDataToEnd32bytesData:hexDataFromBase58];

			[dynamicDataStack addObject:hexDataFromBase58 ? : [self emptyData32bit]];
		}

	} else if ([aType isKindOfClass:[AbiParameterTypeFixedArrayFixedBytes class]]) {

		AbiParameterTypeFixedArrayFixedBytes *type = (AbiParameterTypeFixedArrayFixedBytes *)aType;

		for (int i = 0; i < type.size; i++) {

			NSString *element = arrayElements[i];
			NSMutableData *dataBytes = [[element dataUsingEncoding:NSASCIIStringEncoding] mutableCopy];

			if (dataBytes.length > type.elementSize) {
				dataBytes = [[dataBytes subdataWithRange:NSMakeRange (0, type.elementSize)] mutableCopy];
			}

			[dataBytes increaseLengthBy:standardParameterBatch - dataBytes.length];

			[dynamicDataStack addObject:[dataBytes copy] ? : [self emptyData32bit]];
		}

	}

	//inc offset
	*offset = @([*offset integerValue] + (length * standardParameterBatch) + standardParameterBatch);
}

- (void)convertDynamicStringArrayWithStaticStack:(NSMutableArray *) staticDataArray
								 andDynamicStack:(NSMutableArray *) dynamicDataStack
										withType:(AbiParameterTypeDynamicArrayString *) aType
									   andOffset:(NSNumber **) offset
										withData:(NSString *) data {

	if (![data isKindOfClass:[NSString class]]) {
		return;//bail if wrong data
	}

	//adding offset
	[staticDataArray addObject:[NSData reverseData:[self uint256DataFromInt:[*offset integerValue]]]];

	//adding dynamic data in dynamic stack
	NSArray *arrayElements = [data dynamicArrayStringsFromParameter];
	NSInteger length = arrayElements.count;

	[dynamicDataStack addObject:[NSData reverseData:[self uint256DataFromInt:length]]];

	for (int i = 0; i < arrayElements.count; i++) {

		NSString *element = arrayElements[i];
		NSInteger elementLength = [element dataUsingEncoding:NSUTF8StringEncoding].length;

		[dynamicDataStack addObject:[NSData reverseData:[self uint256DataFromInt:elementLength]]];

		NSData *stringData = [self dataMultiple32bitFromString:element];
		[dynamicDataStack addObject:stringData ? : [self emptyData32bit]];

	}

	//inc offset
	*offset = @([*offset integerValue] + (length * standardParameterBatch) + standardParameterBatch);
}

- (void)convertBytesWithStaticStack:(NSMutableArray *) staticDataArray
					andDynamicStack:(NSMutableArray *) dynamicDataStack
						   withType:(id <AbiParameterProtocol>) type
						  andOffset:(NSNumber **) offset
						   withData:(NSString *) string {

	if (![string isKindOfClass:[NSString class]]) {
		return;//bail if wrong data
	}

	//adding offset
	[staticDataArray addObject:[NSData reverseData:[self uint256DataFromInt:[*offset integerValue]]]];

	//adding dynamic data in dynamic stack
	NSInteger length = [string dataUsingEncoding:NSASCIIStringEncoding].length;
	[dynamicDataStack addObject:[NSData reverseData:[self uint256DataFromInt:length]]];

	NSData *stringData = [self dataMultiple32bitFromString:string];
	[dynamicDataStack addObject:stringData ? : [self emptyData32bit]];

	//inc offset
	*offset = @([*offset integerValue] + stringData.length + standardParameterBatch);
}

- (NSData *)dataOffsetFromIntOffset:(NSInteger) offset {

	return [NSData reverseData:[self uint256DataFromInt:offset]];
}

- (NSData *)uint256DataFromInt:(NSInteger) aInt {

	return [self data32BitsFromInt:aInt withSize:sizeof (NSInteger)];
}

- (NSData *)data32BitsFromInt:(NSInteger) aInt withSize:(NSInteger) aSize {

	NSMutableData *data = [NSMutableData dataWithBytes:&aInt length:aSize];

	if (data.length < 32) {

		[data increaseLengthBy:32 - data.length];
	}
	return [data copy];
}

- (NSDictionary *)uint256DataFromString:(NSString *) aString {

	NSMutableData *data = [[aString dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
	NSInteger shift = (data.length % 32) > 0 ? (data.length / 32 + 1) : data.length / 32;
	shift = shift > 0 ? shift : 1;
	[data increaseLengthBy:32 * shift - data.length];
	return @{@"data": data,
			@"shift": @(shift > 0 ? shift - 1 : shift)};
}

- (NSData *)dataMultiple32bitFromString:(NSString *) aString {

	NSMutableData *data = [[aString dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
	NSInteger expectedLenght = data.length % standardParameterBatch ? (data.length / standardParameterBatch + 1) : data.length / standardParameterBatch;
	expectedLenght = expectedLenght == 0 ? 1 : expectedLenght;
	[data increaseLengthBy:standardParameterBatch * expectedLenght - data.length];
	return [data copy];
}

- (NSData *)data32bitFromString:(NSString *) aString {

	NSMutableData *data = [[aString dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
	NSInteger expectedLenght = data.length % standardParameterBatch ? (data.length / standardParameterBatch + 1) : data.length / standardParameterBatch;
	expectedLenght = expectedLenght == 0 ? 1 : expectedLenght;
	[data increaseLengthBy:standardParameterBatch * expectedLenght - data.length];
	return [data copy];
}

- (NSData *)appendDataToEnd32bytesData:(NSData *) aData {

	NSMutableData *data = [NSMutableData new];
	[data increaseLengthBy:32 - aData.length];
	[data appendData:aData];
	return [data copy];
}

- (NSArray *)аrrayFromContractArguments:(NSData *) data andInterface:(AbiinterfaceItem *) interface {

	if (data.length > 0) {
		NSData *argumentsData = [data mutableCopy];
		NSMutableArray *argumentsArray = @[].mutableCopy;

		for (int i = 0; i < interface.outputs.count; i++) {

			id <AbiParameterProtocol> type = interface.outputs[i].type;

			if ([type isKindOfClass:[AbiParameterTypeUInt class]] ||
					[type isKindOfClass:[AbiParameterTypeInt class]] ||
					[type isKindOfClass:[AbiParameterTypeBool class]]) {

				BTCBigNumber *arg = [self numberFromData:[argumentsData subdataWithRange:NSMakeRange (0, 32)]];
				if (arg) {
					QTUMBigNumber *argVal = [[QTUMBigNumber alloc] initWithString:arg.decimalString];
					[argumentsArray addObject:argVal];
					argumentsData = [argumentsData subdataWithRange:NSMakeRange (32, argumentsData.length - 32)];
				}
			} else if ([type isKindOfClass:[AbiParameterTypeString class]]) {

				BTCBigNumber *offset = [self numberFromData:[argumentsData subdataWithRange:NSMakeRange (0, 32)]];
				BTCBigNumber *length = [self numberFromData:[argumentsData subdataWithRange:NSMakeRange (32, 32)]];
				NSString *stringArg = [self stringFromData:[argumentsData subdataWithRange:NSMakeRange (64, length.uint32value)]];
				if (stringArg) {
					[argumentsArray addObject:stringArg];
					argumentsData = [argumentsData subdataWithRange:NSMakeRange (offset.uint32value + length.uint32value, argumentsData.length - offset.uint32value - length.uint32value)];
				}
			} else if ([type isKindOfClass:[AbiParameterTypeAddress class]]) {

				NSString *arg = [self stringFromData:[argumentsData subdataWithRange:NSMakeRange (0, 32)]];
				if (arg) {
					[argumentsArray addObject:arg];
					argumentsData = [argumentsData subdataWithRange:NSMakeRange (32, argumentsData.length - 32)];
				}
			} else if ([type isKindOfClass:[AbiParameterTypeFixedBytes class]]) {

				NSString *arg = [[NSString alloc] initWithData:[argumentsData subdataWithRange:NSMakeRange (0, 32)] encoding:NSUTF8StringEncoding];
				if (arg) {
					[argumentsArray addObject:arg];
					argumentsData = [argumentsData subdataWithRange:NSMakeRange (32, argumentsData.length - 32)];
				}
			}
		}
		return argumentsArray;
	} else {
		return nil;
	}
}

- (NSString *)stringFromData:(NSData *) data {

	return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (BTCBigNumber *)numberFromData:(NSData *) data {

	BTCBigNumber *bigNumber = [[BTCBigNumber alloc] initWithUnsignedBigEndian:data];
	return bigNumber;
}

- (NSData *)emptyData32bit {

	NSMutableData *empty = [NSMutableData new];
	[empty increaseLengthBy:32];
	return [empty copy];
}

@end
