//
//  ContractManager.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 16.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "ContractManager.h"
#import "InterfaceInputFormModel.h"
#import "ContractFileManager.h"
#import "ContractArgumentsInterpretator.h"
#import "ResultTokenInputsModel.h"
#import "AbiinterfaceItem.h"
#import "NSString+SHA3.h"

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

- (NSString*)getHashOfFunction:(AbiinterfaceItem*) fuctionItem andParam:(NSArray<ResultTokenInputsModel*>*)inputs{
    
    NSMutableString* param = [NSMutableString new];
    for (int i = 0; i < fuctionItem.inputs.count; i++) {
        if (i != fuctionItem.inputs.count - 1) {
            [param appendFormat:@"%@,",fuctionItem.inputs[i].typeAsString];
        } else {
            [param appendString:fuctionItem.inputs[i].typeAsString];
        }
    }
    NSString* functionSignature = [NSString stringWithFormat:@"%@(%@)",fuctionItem.name,param];
//        NSString* functionSignature = @"name()";

    
    return [[functionSignature sha3:256] substringToIndex:8];
}





@end
