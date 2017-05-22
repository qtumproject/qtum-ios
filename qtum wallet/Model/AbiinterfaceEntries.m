//
//  AbiinterfaceEntries.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
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
        _name = [object[@"name"] isKindOfClass:[NSNull class]] ? nil : [NSString stringFromCamelCase:object[@"name"]];
        _typeAsString = object[@"type"];
        _type = [self determineTipe:object[@"type"]];
    }
}

-(AbiInputType)determineTipe:(NSString*) typeString {
    
    if ([typeString isEqualToString:@"uint256"]) {
        return UInt256Type;
    } else if ([typeString isEqualToString:@"uint8"]){
        return UInt8Type;
    } else if ([typeString isEqualToString:@"string"]) {
        return StringType;
    }
    
    return BoolType;
}


@end
