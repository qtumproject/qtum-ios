//
//  AbiTypesProcessor.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbiParameterProtocol.h"
#import "AbiParameterTypeInt.h"
#import "AbiParameterTypeUInt.h"
#import "AbiParameterTypeArray.h"
#import "AbiParameterTypeBytes.h"
#import "AbiParameterTypeString.h"
#import "AbiParameterTypeFixedBytes.h"
#import "AbiParameterTypeAddress.h"
#import "AbiParameterTypeBool.h"
#import "AbiParameterTypeFixedBytes.h"
#import "AbiParameterTypeFixedArrayInt.h"
#import "AbiParameterTypeFixedArrayUInt.h"
#import "AbiParameterTypeFixedArrayBool.h"
#import "AbiParameterTypeFixedArrayString.h"
#import "AbiParameterTypeFixedArrayFixedBytes.h"
#import "AbiParameterTypeFixedArrayAddress.h"
#import "AbiParameterTypeFixedArrayBytes.h"
#import "AbiParameterTypeDynamicArrayInt.h"
#import "AbiParameterTypeDynamicArrayUInt.h"
#import "AbiParameterTypeDynamicArrayBool.h"
#import "AbiParameterTypeDynamicArrayString.h"
#import "AbiParameterTypeDynamicArrayFixedBytes.h"
#import "AbiParameterTypeDynamicArrayBytes.h"
#import "AbiParameterTypeDynamicArrayAddress.h"

@interface AbiTypesProcessor : NSObject

+ (id <AbiParameterProtocol>)typeFromAbiString:(NSString *) typeString;

@end
