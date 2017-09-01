//
//  ContractArgumentsInterpretator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 18.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "ContractArgumentsInterpretator.h"
#import "NSData+Extension.h"
#import "AbiinterfaceItem.h"
#import "NSString+Extension.h"

@interface ContractArgumentsInterpretator ()

@end

@implementation ContractArgumentsInterpretator

NSInteger standardParameterBatch = 32;

+ (instancetype)sharedInstance {
    
    static ContractArgumentsInterpretator *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] initUniqueInstance];
    });
    return instance;
}

- (instancetype)initUniqueInstance {
    
    self = [super init];
    
    if (self != nil) {
        
    }
    return self;
}

- (NSData*)contactArgumentsFromDictionary:(NSDictionary*) dict{
    return nil;
}

- (NSData*)contactArgumentsFromArrayOfValues:(NSArray<NSString*>*) values andArrayOfTypes:(NSArray*) types {
    
    NSMutableData* args = [NSMutableData new];
    NSMutableArray* staticDataArray = @[].mutableCopy;
    NSMutableArray* dynamicDataArray = @[].mutableCopy;
    NSNumber* offset = @(32 * values.count);
    
    //decode data
    for (int i = 0; i < values.count; i++) {
        
        id <AbiParameterProtocol> type = types[i];
        
        //decode arrays
        if ([type isKindOfClass:[AbiParameterTypeArray class]] ) {
            
            
        }
        
        //decode primitive types
        else if ([type isKindOfClass:[AbiParameterPrimitiveType class]] ||
                   [type isKindOfClass:[AbiParameterTypeAddress class]]) {
            
            [self convertElementaryTypesWith:staticDataArray withType:type andOffset:&offset withData:values[i]];
            
        }
        
        //decode strings
        else if ([type isKindOfClass:[AbiParameterTypeString class]]){
            
            [self convertStringsWithStaticStack:staticDataArray andDynamicStack:dynamicDataArray withType:type andOffset:&offset withData:values[i]];
        }
        
        //decode bytes
        else if ([type isKindOfClass:[AbiParameterTypeBytes class]]){
            
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

- (void)convertElementaryTypesWith:(NSMutableArray*)staticDataArray
                          withType:(id <AbiParameterProtocol>)type
                         andOffset:(NSNumber**)offset
                          withData:(NSString*)data {
    
    if (![data isKindOfClass:[NSString class]]) {
        return;//bail if wrong data
    }
    
    if ([type isKindOfClass:[AbiParameterTypeUInt class]]) {
        
        NSInteger param = [data integerValue];
        [staticDataArray addObject:[NSData reverseData:[self uint256DataFromInt:param]] ?: [self emptyData32bit]];
    } else if ([type isKindOfClass:[AbiParameterTypeBool class]]) {
        
        NSInteger param = [data integerValue];
        [staticDataArray addObject:[NSData reverseData:[self data32BitsFromInt:param withSize:1]] ?: [self emptyData32bit]];
    } else if ([type isKindOfClass:[AbiParameterTypeAddress class]]) {
        
        
        NSMutableData* address = [[NSString dataFromHexString:data] mutableCopy];
        if (address.length > 20) {
            address = [[address subdataWithRange:NSMakeRange(0, 20)] mutableCopy];
        }
        [address increaseLengthBy:32 - address.length];
        
        [staticDataArray addObject:[NSData reverseData:[address copy]] ?: [self emptyData32bit]];
        
    } else if ([type isKindOfClass:[AbiParameterTypeFixedBytes class]]) {
        
        AbiParameterTypeFixedBytes* bytesType = (AbiParameterTypeFixedBytes*)type;
        NSMutableData* dataBytes = [[data dataUsingEncoding:NSASCIIStringEncoding] mutableCopy];
        
        if (dataBytes.length > bytesType.size) {
            dataBytes = [[dataBytes subdataWithRange:NSMakeRange(0, bytesType.size)] mutableCopy];
        } else {
            [dataBytes increaseLengthBy:bytesType.size - dataBytes.length];
        }
        
        [staticDataArray addObject:[dataBytes copy]?: [self emptyData32bit]];
    }
}

- (void)convertStringsWithStaticStack:(NSMutableArray*)staticDataArray
                      andDynamicStack:(NSMutableArray*)dynamicDataStack
                             withType:(id <AbiParameterProtocol>)type
                            andOffset:(NSNumber**)offset
                             withData:(NSString*)string {
    
    if (![string isKindOfClass:[NSString class]]) {
        return;//bail if wrong data
    }
    
    //adding offset
    [staticDataArray addObject:[NSData reverseData:[self uint256DataFromInt:[*offset integerValue]]]];
    
    //adding dynamic data in dynamic stack
    NSInteger length = [string dataUsingEncoding:NSUTF8StringEncoding].length;
    [dynamicDataStack addObject:[NSData reverseData:[self uint256DataFromInt:length]]];
    
    NSData* stringData = [self dataMultiple32bitFromString:string];
    [dynamicDataStack addObject:stringData ?: [self emptyData32bit]];
    
    //inc offset
    *offset = @([*offset integerValue] + stringData.length + standardParameterBatch);
}

- (void)convertBytesWithStaticStack:(NSMutableArray*)staticDataArray
                      andDynamicStack:(NSMutableArray*)dynamicDataStack
                             withType:(id <AbiParameterProtocol>)type
                            andOffset:(NSNumber**)offset
                             withData:(NSString*)string {
    
    if (![string isKindOfClass:[NSString class]]) {
        return;//bail if wrong data
    }
    
    //adding offset
    [staticDataArray addObject:[NSData reverseData:[self uint256DataFromInt:[*offset integerValue]]]];
    
    //adding dynamic data in dynamic stack
    NSInteger length = [string dataUsingEncoding:NSASCIIStringEncoding].length;
    [dynamicDataStack addObject:[NSData reverseData:[self uint256DataFromInt:length]]];
    
    NSData* stringData = [self dataMultiple32bitFromString:string];
    [dynamicDataStack addObject:stringData ?: [self emptyData32bit]];
    
    //inc offset
    *offset = @([*offset integerValue] + stringData.length + standardParameterBatch);
}

- (NSData*)dataOffsetFromIntOffset:(NSInteger) offset {
    
    return [NSData reverseData:[self uint256DataFromInt:offset]];
}

- (BTC256)btc256FromInt:(NSInteger) aInt {
    
    NSMutableData* data = [NSMutableData dataWithBytes:&aInt length:sizeof(NSInteger)];
    [data increaseLengthBy:32 - data.length];
    return BTC256FromNSData(data);
}

- (NSData*)uint256DataFromInt:(NSInteger) aInt {
    
    return [self data32BitsFromInt:aInt withSize:sizeof(NSInteger)];
}

-(NSData*)data32BitsFromInt:(NSInteger) aInt withSize:(NSInteger) aSize {
    
    NSMutableData* data = [NSMutableData dataWithBytes:&aInt length:aSize];
    
    if (data.length < 32) {
        
        [data increaseLengthBy:32 - data.length];
    }
    return [data copy];
}

- (NSDictionary*)uint256DataFromString:(NSString*) aString {
    
    NSMutableData* data = [[aString dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    NSInteger shift = (data.length % 32) > 0 ? (data.length / 32 + 1) : data.length / 32;
    shift = shift > 0 ? shift : 1;
    [data increaseLengthBy:32 * shift - data.length];
    return @{@"data":data,
             @"shift" : @(shift > 0 ? shift - 1: shift)};
}

- (NSData*)dataMultiple32bitFromString:(NSString*) aString {
    
    NSMutableData* data = [[aString dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    NSInteger expectedLenght = data.length % standardParameterBatch ? (data.length / standardParameterBatch + 1) : data.length / standardParameterBatch;
    expectedLenght = expectedLenght == 0 ? 1 : expectedLenght;
    [data increaseLengthBy:standardParameterBatch * expectedLenght - data.length];
    return [data copy];
}

- (NSData*)data32bitFromString:(NSString*) aString {
    
    NSMutableData* data = [[aString dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    NSInteger expectedLenght = data.length % standardParameterBatch ? (data.length / standardParameterBatch + 1) : data.length / standardParameterBatch;
    expectedLenght = expectedLenght == 0 ? 1 : expectedLenght;
    [data increaseLengthBy:standardParameterBatch * expectedLenght - data.length];
    return [data copy];
}

- (NSData*)uint256DataFromData:(NSData*) aData {
    
    NSMutableData* emptyData = [NSMutableData new];
    [emptyData increaseLengthBy:32 - aData.length];
    [emptyData appendData:aData];
    return emptyData;
}

- (NSArray*)аrrayFromContractArguments:(NSData*) data andInterface:(AbiinterfaceItem*) interface {
    
    if (data.length > 0){
        NSData* argumentsData = [data mutableCopy];
        NSMutableArray* argumentsArray = @[].mutableCopy;
        
        for (int i = 0; i < interface.outputs.count; i++) {
            
            id <AbiParameterProtocol> type = interface.outputs[i].type;

            if([type isKindOfClass:[AbiParameterTypeUInt class]] ||
               [type isKindOfClass:[AbiParameterTypeInt class]] ||
               [type isKindOfClass:[AbiParameterTypeBool class]]) {
                
                NSNumber* arg = @([self numberFromData:[argumentsData subdataWithRange:NSMakeRange(0, 32)]]);
                if (arg){
                    [argumentsArray addObject:arg];
                    argumentsData = [argumentsData subdataWithRange:NSMakeRange(32, argumentsData.length - 32)];
                }
            } else if([type isKindOfClass:[AbiParameterTypeString class]]) {
                
                NSUInteger offset = [self numberFromData:[argumentsData subdataWithRange:NSMakeRange(0, 32)]];
                NSUInteger length = [self numberFromData:[argumentsData subdataWithRange:NSMakeRange(32, 32)]];
                NSString* stringArg = [self stringFromData:[argumentsData subdataWithRange:NSMakeRange(64, length)]];
                if (stringArg){
                    [argumentsArray addObject:stringArg];
                    argumentsData = [argumentsData subdataWithRange:NSMakeRange(offset + length, argumentsData.length - offset - length)];
                }
            } else if([type isKindOfClass:[AbiParameterTypeAddress class]]) {
                
                NSString* arg = [self stringFromData:[argumentsData subdataWithRange:NSMakeRange(0, 32)]];
                if (arg){
                    [argumentsArray addObject:arg];
                    argumentsData = [argumentsData subdataWithRange:NSMakeRange(32, argumentsData.length - 32)];
                }
            } else if([type isKindOfClass:[AbiParameterTypeFixedBytes class]]) {
                
                NSString* arg = [[NSString alloc] initWithData:[argumentsData subdataWithRange:NSMakeRange(0, 32)] encoding:NSUTF8StringEncoding];
                if (arg){
                    [argumentsArray addObject:arg];
                    argumentsData = [argumentsData subdataWithRange:NSMakeRange(32, argumentsData.length - 32)];
                }
            }
        }
        return argumentsArray;
    } else {
        return nil;
    }
}

- (NSString*)stringFromData:(NSData*) data {
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSUInteger)numberFromData:(NSData*) data {

    NSInteger availableSize = 4;
    unsigned long long dataAsInt = 0;
    if (data.length >= availableSize) {
        NSData* newData = [data subdataWithRange:NSMakeRange(data.length - availableSize, availableSize)];
        
        NSString *stringData = [newData description];
        stringData = [stringData substringWithRange:NSMakeRange(1, [stringData length]-2)];
        
        NSScanner *scanner = [NSScanner scannerWithString: stringData];
        [scanner scanHexLongLong:& dataAsInt];
    }

    return dataAsInt;
}

-(NSData*)emptyData32bit {
    
    NSMutableData* empty = [NSMutableData new];
    [empty increaseLengthBy:32];
    return [empty copy];
}

@end
