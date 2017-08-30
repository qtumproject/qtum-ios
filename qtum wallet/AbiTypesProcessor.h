//
//  AbiTypesProcessor.h
//  qtum wallet
//
//  Created by Никита Федоренко on 30.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
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

@interface AbiTypesProcessor : NSObject

+ (id <AbiParameterProtocol>)typeFromAbiString:(NSString*) typeString;

@end
