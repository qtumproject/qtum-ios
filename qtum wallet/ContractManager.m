//
//  ContractManager.m
//  qtum wallet
//
//  Created by Никита Федоренко on 16.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "ContractManager.h"
#import "InterfaceInputFormModel.h"
#import "ContractFileManager.h"
#import "ContractArgumentsInterpretator.h"

@implementation ContractManager

+ (instancetype)sharedInstance {
    
    static ContractManager *instance;
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

- (InterfaceInputFormModel*)getStandartTokenIntephase {
    
    InterfaceInputFormModel* interphase = [[InterfaceInputFormModel alloc] initWithAbi:[ContractFileManager getAbiFromBundle]];
    return interphase;
}

- (NSData*)getStandartTokenBitecodeWithParam:(NSDictionary*) args{
    
    NSMutableData* contractSource = [[ContractFileManager getBitcodeFromBundle] mutableCopy];
    [contractSource appendData:[ContractArgumentsInterpretator contactArgumentsFromDictionary:args]];
    return [contractSource copy];
}

- (NSData*)getStandartTokenBitecodeWithArray:(NSArray*) args{
    
    NSMutableData* contractSource = [[ContractFileManager getBitcodeFromBundle] mutableCopy];
    [contractSource appendData:[ContractArgumentsInterpretator contactArgumentsFromArray:args]];
    return [contractSource copy];
}



@end
