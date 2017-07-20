//
//  InterphaseInputFormModel.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 16.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "InterfaceInputFormModel.h"
#import "AbiinterfaceItem.h"

@interface InterfaceInputFormModel ()

@property (strong, nonatomic) NSMutableArray<AbiinterfaceItem*>* propertyItems;
@property (strong, nonatomic) NSMutableArray<AbiinterfaceItem*>* functionItems;
@property (strong, nonatomic) AbiinterfaceItem* constructorItem;

@end

@implementation InterfaceInputFormModel

-(instancetype)initWithAbi:(NSArray*) abi{
    
    self = [super init];
    if (self) {
        [self setUpWithObject:abi];
    }
    return self;
}

-(void)setUpWithObject:(NSArray*) abi {
    
    for (NSDictionary* item in abi) {
        AbiinterfaceItem* abiItem = [[AbiinterfaceItem alloc] initWithObject:item];
        if (abiItem.type == Function && abiItem.constant) {
            [self.propertyItems addObject:abiItem];
        } else if(abiItem.type == Function) {
            [self.functionItems addObject:abiItem];
        } else if(abiItem.type == Constructor) {
            self.constructorItem = abiItem;
        }
    }
}

#pragma mark - Getters

-(NSArray<AbiinterfaceItem *> *)functionItems {
    
    if (!_functionItems) {
        _functionItems = @[].mutableCopy;
    }
    return _functionItems;
}

-(NSArray<AbiinterfaceItem *> *)propertyItems {
    
    if (!_propertyItems) {
        _propertyItems = @[].mutableCopy;
    }
    return _propertyItems;
}

-(BOOL)contains:(InterfaceInputFormModel*) inerface {
    
    for (AbiinterfaceItem* function in inerface.functionItems) {
        if (![self containsFunction:function]) {
            return NO;
        }
    }
    
    for (AbiinterfaceItem* parameter in inerface.propertyItems) {
        if (![self containsParameter:parameter]) {
            return NO;
        }
    }
    
    return YES;
}

-(BOOL)containsItem:(AbiinterfaceItem*) inerfaceItem {
    
    if ([self containsFunction:inerfaceItem]) {
        return YES;
    } else if([self containsParameter:inerfaceItem]){
        return YES;
    }
    return NO;
}

-(BOOL)containsParameter:(AbiinterfaceItem*) param {
    
    return [self.propertyItems containsObject:param];
}

-(BOOL)containsFunction:(AbiinterfaceItem*) func {
    
    return [self.functionItems containsObject:func];
}

@end
