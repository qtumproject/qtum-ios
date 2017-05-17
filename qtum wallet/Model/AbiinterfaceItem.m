//
//  AbiIntephaseItem.m
//  qtum wallet
//
//  Created by Никита Федоренко on 17.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "AbiinterfaceItem.h"

@interface AbiinterfaceItem ()

@property (copy, nonatomic) NSString* name;
@property (assign, nonatomic) BOOL constant;
@property (assign, nonatomic) BOOL payable;
@property (assign, nonatomic) AbiItemType type;
@property (strong, nonatomic) NSArray <AbiinterfaceInput*>* inputs;
@property (strong, nonatomic) NSArray <AbiInterfaceOutput*>* outputs;

@end

@implementation AbiinterfaceItem

-(instancetype)initWithObject:(id) object {
    
    self = [super init];
    if (self) {
        [self setUpWithObject:object];
    }
    return self;
}

-(void)setUpWithObject:(id) object {
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        _name = [object[@"name"] isKindOfClass:[NSNull class]] ? nil : object[@"name"];
        _constant = [object[@"constant"] isKindOfClass:[NSNull class]] ? : [object[@"constant"] boolValue];
        _payable = [object[@"payable"] isKindOfClass:[NSNull class]] ? : [object[@"payable"] boolValue];
        _type = [self determineTipe:object[@"type"]];
        _inputs = [self setupInputs:object[@"inputs"]];
        _outputs = [self setupOutputs:object[@"outputs"]];
    }
}

-(AbiItemType)determineTipe:(NSString*) typeString {
    
    if ([typeString isEqualToString:@"function"]) {
        return Function;
    } else if ([typeString isEqualToString:@"constructor"]){
        return Constructor;
    } else if ([typeString isEqualToString:@"fallback"]) {
        return Fallback;
    }

    return Undefined;
}

-(NSArray <AbiinterfaceInput*>*)setupInputs:(NSDictionary*) inputs {
    
    NSMutableArray* entries = @[].mutableCopy;
    for (NSDictionary* item in inputs) {
        AbiinterfaceInput* inputItem = [[AbiinterfaceInput alloc] initWithObject:item];
        [entries addObject:inputItem];
    }
    
    return entries;
}

-(NSArray <AbiInterfaceOutput*>*)setupOutputs:(NSDictionary*) outputs {
    
    NSMutableArray* entries = @[].mutableCopy;
    for (NSDictionary* item in outputs) {
        AbiinterfaceInput* outputItem = [[AbiinterfaceInput alloc] initWithObject:item];
        [entries addObject:outputItem];
    }
    
    return entries;
}

@end
