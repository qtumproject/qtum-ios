//
//  AbiTypesProcessor.m
//  qtum wallet
//
//  Created by Никита Федоренко on 30.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "AbiTypesProcessor.h"
#import "NSString+AbiRegex.h"

@implementation AbiTypesProcessor

+(id <AbiParameterProtocol>)typeFromAbiString:(NSString*) typeString {
    
    if ([typeString isUintFromAbi]) {
        
        AbiParameterTypeUInt* type = [[AbiParameterTypeUInt alloc] initWithSize:[typeString uintSize]];
        return type;
    } else if ([typeString isStringFromAbi]) {
        
        AbiParameterTypeString* type = [AbiParameterTypeString new];
        return type;
    } else if ([typeString isAddressFromAbi]) {
        
        AbiParameterTypeAddress* type = [AbiParameterTypeAddress new];
        return type;
    } else if ([typeString isBytesFromAbi]) {
        
        AbiParameterTypeBytes* type = [AbiParameterTypeBytes new];
        return type;
    } else if ([typeString isBytesFixedFromAbi]) {
        
        AbiParameterTypeFixedBytes* type = [[AbiParameterTypeFixedBytes alloc] initWithSize:[typeString fixedBytesSize]];
        return type;
    } else if ([typeString isBoolFromAbi]) {
        
        AbiParameterTypeBool* type = [[AbiParameterTypeBool alloc] initWithSize:0];
        return type;
    }
    
    return [AbiParameterTypeAddress new];
}

@end
