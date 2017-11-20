//
//  AbiinterfaceEntries.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//


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
        _type = [self determineTipe:object[@"type"]];
        _typeAsString = object[@"type"];
        _name = [object[@"name"] isKindOfClass:[NSNull class]] ? nil : [[NSString stringFromCamelCase:object[@"name"]] stringByReplacingOccurrencesOfString:@"_" withString:@""];
        if (!_name || [_name isEqualToString:@""]) {
            _name = _typeAsString;
        }
    }
}

-(id <AbiParameterProtocol>)determineTipe:(NSString*) typeString {
    
    return [AbiTypesProcessor typeFromAbiString:typeString];
}

#pragma mark - Equality

- (BOOL)isEqualToInput:(AbiinterfaceEntries *)aInput {

    if (!aInput) {
        return NO;
    }
    
    BOOL haveEqualType = [self.type isKindOfClass:[aInput.type class]];

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
    
    return [self.name hash];
}


@end
