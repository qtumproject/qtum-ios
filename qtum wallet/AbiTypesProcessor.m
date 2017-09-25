//
//  AbiTypesProcessor.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "AbiTypesProcessor.h"
#import "NSString+AbiRegex.h"

@implementation AbiTypesProcessor

+(id <AbiParameterProtocol>)typeFromAbiString:(NSString*) typeString {
    
    if ([typeString isArrayFromAbi]) {
        
        if ([typeString isFixedArrayOfUintFromAbi]) {
            
            AbiParameterTypeFixedArrayUInt* type = [[AbiParameterTypeFixedArrayUInt alloc] initWithSize:[typeString arraySize]];
            return type;
        } else if ([typeString isDynamicArrayOfUintFromAbi]){
            
            AbiParameterTypeDynamicArrayUInt* type = [AbiParameterTypeDynamicArrayUInt new];
            return type;
        } else if ([typeString isFixedArrayOfIntFromAbi]){
            
            AbiParameterTypeFixedArrayInt* type = [[AbiParameterTypeFixedArrayInt alloc] initWithSize:[typeString arraySize]];
            return type;
        } else if ([typeString isDynamicArrayOfIntFromAbi]){
            
            AbiParameterTypeDynamicArrayInt* type = [AbiParameterTypeDynamicArrayInt new];
            return type;
        } else if ([typeString isFixedArrayOfBoolFromAbi]){
            
            AbiParameterTypeFixedArrayBool* type = [[AbiParameterTypeFixedArrayBool alloc] initWithSize:[typeString arraySize]];
            return type;
        } else if ([typeString isDynamicArrayOfBoolFromAbi]){
            
            AbiParameterTypeDynamicArrayBool* type = [AbiParameterTypeDynamicArrayBool new];
            return type;
        } else if ([typeString isFixedArrayOfBytesFromAbi]){
            
            AbiParameterTypeFixedArrayBytes* type = [[AbiParameterTypeFixedArrayBytes alloc] initWithSize:[typeString arraySize]];
            return type;
        } else if ([typeString isDynamicArrayOfBytesFromAbi]){
            
            AbiParameterTypeDynamicArrayBytes* type = [AbiParameterTypeDynamicArrayBytes new];
            return type;
        } else if ([typeString isFixedArrayOfStringFromAbi]){
            
            AbiParameterTypeFixedArrayString* type = [[AbiParameterTypeFixedArrayString alloc] initWithSize:[typeString arraySize]];
            return type;
        } else if ([typeString isDynamicArrayOfStringFromAbi]){
            
            AbiParameterTypeDynamicArrayString* type = [AbiParameterTypeDynamicArrayString new];
            return type;
        } else if ([typeString isFixedArrayOfFixedBytesFromAbi]){
            
            AbiParameterTypeFixedArrayFixedBytes* type = [[AbiParameterTypeFixedArrayFixedBytes alloc] initWithSize:[typeString arraySize]];
            return type;
        } else if ([typeString isDynamicArrayOfFixedBytesFromAbi]){
            
            AbiParameterTypeDynamicArrayFixedBytes* type = [AbiParameterTypeDynamicArrayFixedBytes new];
            return type;
        } else if ([typeString isFixedArrayOfAddressesFromAbi]){
            
            AbiParameterTypeFixedArrayAddress* type = [[AbiParameterTypeFixedArrayAddress alloc] initWithSize:[typeString arraySize]];
            return type;
        } else if ([typeString isDynamicArrayOfAddressesFromAbi]){
            
            AbiParameterTypeDynamicArrayAddress* type = [AbiParameterTypeDynamicArrayAddress new];
            return type;
        }
    } else {
        
        if ([typeString isUintFromAbi]) {
            
            AbiParameterTypeUInt* type = [[AbiParameterTypeUInt alloc] initWithSize:[typeString uintSize]];
            return type;
        } else if ([typeString isIntFromAbi]) {
            
            AbiParameterTypeInt* type = [[AbiParameterTypeInt alloc] initWithSize:[typeString intSize]];
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
    }
    
    return [AbiParameterTypeAddress new];
}

@end
