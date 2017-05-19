//
//  InterphaseInputFormModel.m
//  qtum wallet
//
//  Created by Никита Федоренко on 16.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "InterfaceInputFormModel.h"
#import "AbiinterfaceItem.h"

@interface InterfaceInputFormModel ()

@property (strong, nonatomic) NSMutableArray<AbiinterfaceItem*>* functionItems;
@property (strong, nonatomic) AbiinterfaceItem* constructorItem;

@end

@implementation InterfaceInputFormModel

-(instancetype)initWithAbi:(NSDictionary*) abi{
    
    self = [super init];
    if (self) {
        [self setUpWithObject:abi];
    }
    return self;
}

-(void)setUpWithObject:(NSDictionary*) abi {
    
    for (NSDictionary* item in abi) {
        AbiinterfaceItem* abiItem = [[AbiinterfaceItem alloc] initWithObject:item];
        if (abiItem.type == Function) {
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

@end
