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

@implementation ContractArgumentsInterpretator

+(NSData*)contactArgumentsFromDictionary:(NSDictionary*) dict{
    return nil;
}

+(NSData*)contactArgumentsFromArray:(NSArray*) array {
    
    //array = @[@123,@456,@"thequickbrownfoxjumpsoverthelazydog",@"shesellsseashellsontheseashore"];
    
    NSMutableData* args = [NSMutableData new];
    NSInteger constantOffset = 32;
    NSInteger nextStingOffset = constantOffset * array.count;
    NSMutableArray* stringsArray = @[].mutableCopy;
    
    for (int i = 0; i < array.count; i++) {
        
        if ([array[i] isKindOfClass:[NSNumber class]]) {
            
            NSInteger param = [array[i] integerValue];
            [args appendData:[NSData reverseData:[self uint256DataFromInt:param]]];
            
        } else if ([array[i] isKindOfClass:[NSString class]]){
            
            NSMutableDictionary* stringDict = @{}.mutableCopy;
            NSString* param = array[i];
            
            //because not all symbols decoding as 2 bite
            NSInteger length = [param dataUsingEncoding:NSUTF8StringEncoding].length * 2;
            //[args appendData:[NSData reverseData:[self uint256DataFromInt:length]]];
            stringDict[@"length"] = [NSData reverseData:[self uint256DataFromInt:length]];
            
            [args appendData:[NSData reverseData:[self uint256DataFromInt:nextStingOffset]]];
            
            NSDictionary* dict = [self uint256DataFromString:param];
            //[args appendData:dict[@"data"]];
            nextStingOffset += (constantOffset * ([dict[@"shift"] integerValue] + 1) + constantOffset);
            stringDict[@"value"] = dict[@"data"];
            [stringsArray addObject:[stringDict copy]];
            
        } else if ([array[i] isKindOfClass:[NSData class]]) {
            NSData* param = array[i];
            [args appendData:[self uint256DataFromData:param]];
        }
    }
    
    for (int i = 0; i < stringsArray.count; i++) {
        [args appendData:stringsArray[i][@"length"]];
        [args appendData:stringsArray[i][@"value"]];
    }
    
    return args;
}

+(BTC256)btc256FromInt:(NSInteger) aInt {
    NSMutableData* data = [NSMutableData dataWithBytes:&aInt length:sizeof(NSInteger)];
    [data increaseLengthBy:32 - data.length];
    return BTC256FromNSData(data);
}

+(NSData*)uint256DataFromInt:(NSInteger) aInt {
    NSMutableData* data = [NSMutableData dataWithBytes:&aInt length:sizeof(NSInteger)];
    [data increaseLengthBy:32 - data.length];
    return [data copy];
}

+(NSDictionary*)uint256DataFromString:(NSString*) aString {
    NSMutableData* data = [[aString dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    NSInteger shift = (data.length % 32) > 0 ? (data.length / 32 + 1) : data.length / 32;
    shift = shift > 0 ? shift : 1;
    [data increaseLengthBy:32 * shift - data.length];
    return @{@"data":data,
             @"shift" : @(shift > 0 ? shift - 1: shift)};
}

+(NSData*)uint256DataFromData:(NSData*) aData {
    NSMutableData* emptyData = [NSMutableData new];
    [emptyData increaseLengthBy:32 - aData.length];
    [emptyData appendData:aData];
    return emptyData;
}

+(NSArray*)аrrayFromContractArguments:(NSData*) data andInterface:(AbiinterfaceItem*) interface {
    if (data.length > 0){
        NSData* argumentsData = [data mutableCopy];
        NSMutableArray* argumentsArray = @[].mutableCopy;
        
        for (int i = 0; i < interface.outputs.count; i++) {
            
            if(interface.outputs[i].type == UInt8Type || interface.outputs[i].type == UInt256Type) {
                
                NSNumber* arg = @([self numberFromData:[argumentsData subdataWithRange:NSMakeRange(0, 32)]]);
                if (arg){
                    [argumentsArray addObject:arg];
                    argumentsData = [argumentsData subdataWithRange:NSMakeRange(32, argumentsData.length - 32)];
                }
            } else if(interface.outputs[i].type == StringType) {
                
                NSUInteger offset = [self numberFromData:[argumentsData subdataWithRange:NSMakeRange(0, 32)]];
                NSUInteger length = [self numberFromData:[argumentsData subdataWithRange:NSMakeRange(32, 32)]];
                NSString* stringArg = [self stringFromData:[argumentsData subdataWithRange:NSMakeRange(64, length)]];
                if (stringArg){
                    [argumentsArray addObject:stringArg];
                    argumentsData = [argumentsData subdataWithRange:NSMakeRange(offset + length, argumentsData.length - offset - length)];
                }
            }
        }
        return argumentsArray;
    } else {
        return nil;
    }
}

+(NSString*)stringFromData:(NSData*) data {
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+(NSUInteger)numberFromData:(NSData*) data {

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

@end
