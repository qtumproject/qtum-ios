//
//  AbiinterfaceEntries.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "AbiinterfaceEntries.h"
#import "NSString+Extension.h"

@implementation AbiinterfaceEntries


-(instancetype)initWithObject:(id) object {
    
    self = [super init];
    if (self) {
        [self setUpWithObject:object];
    }
    return self;
}

-(void)setUpWithObject:(id) object {
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        _name = [object[@"name"] isKindOfClass:[NSNull class]] ? nil : [[NSString stringFromCamelCase:object[@"name"]] stringByReplacingOccurrencesOfString:@"_" withString:@""];
        _typeAsString = object[@"type"];
        _type = [self determineTipe:object[@"type"]];
    }
}

-(AbiInputType)determineTipe:(NSString*) typeString {
    
    if ([typeString isEqualToString:@"uint256"] || [typeString isEqualToString:@"uint"]) {
        return UInt256Type;
    } else if ([typeString isEqualToString:@"uint8"]){
        return UInt8Type;
    } else if ([typeString isEqualToString:@"string"]) {
        return StringType;
    } else if ([typeString isEqualToString:@"address"]) {
        return AddressType;
    } 
    
    return BoolType;
}

#pragma mark - Equality

- (BOOL)isEqualToInput:(AbiinterfaceEntries *)aInput {

    if (!aInput) {
        return NO;
    }
    
    BOOL haveEqualType = self.type == aInput.type;

    return haveEqualType;
}

- (BOOL)isEqual:(id)anObject {

    if (self == anObject) {
        return YES;
    }

    if (![anObject isKindOfClass:[AbiinterfaceEntries class]]) {
        return NO;
    }

    return [self isEqualToInput:(AbiinterfaceEntries *)anObject];
}

- (NSUInteger)hash {
    
    return [self.name hash] ^ self.type;
}


@end
