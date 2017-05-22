//
//  ContractArgumentsInterpretator.m
//  qtum wallet
//
//  Created by Никита Федоренко on 18.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "ContractArgumentsInterpretator.h"
#import "NSData+Extension.h"

@implementation ContractArgumentsInterpretator

+(NSData*)contactArgumentsFromDictionary:(NSDictionary*) dict{
    return nil;
}

+(NSData*)contactArgumentsFromArray:(NSArray*) array {
    
    //array = @[@123,@456,@"thequickbrownfoxjumpsoverthelazydog",@"shesellsseashellsontheseashore"];
    
    NSMutableData* args = [NSMutableData new];
    NSInteger nextStingOffset = 0;
    NSInteger constantOffset = 32;
    NSMutableArray* stringsArray = @[].mutableCopy;

    
    for (int i = 0; i < array.count; i++) {
        
        if ([array[i] isKindOfClass:[NSNumber class]]) {
            NSInteger param = [array[i] integerValue];
            nextStingOffset += constantOffset;
            [args appendData:[NSData reverseData:[self uint256DataFromInt:param]]];
            
        } else if ([array[i] isKindOfClass:[NSString class]]){
            
            NSMutableDictionary* stringDict = @{}.mutableCopy;
            nextStingOffset += constantOffset;
            NSString* param = array[i];
            
            NSInteger length = param.length;
            //[args appendData:[NSData reverseData:[self uint256DataFromInt:length]]];
            [stringDict setObject:[NSData reverseData:[self uint256DataFromInt:length]] forKey:@"length"];
            nextStingOffset += constantOffset;
            [stringDict setObject:[NSData reverseData:[self uint256DataFromInt:nextStingOffset]] forKey:@"offset"];
            NSDictionary* dict = [self uint256DataFromString:param];
            //[args appendData:dict[@"data"]];
            nextStingOffset += (constantOffset * [dict[@"shift"] integerValue]);
            [stringDict setObject:dict[@"data"] forKey:@"value"];
            [stringsArray addObject:[stringDict copy]];
        }
    }
    
    for (int i = 0; i < stringsArray.count; i++) {
        [args appendData:stringsArray[i][@"offset"]];
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

@end
