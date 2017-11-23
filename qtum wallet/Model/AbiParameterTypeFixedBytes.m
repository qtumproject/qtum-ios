//
//  AbiParameterTypeFixedBytes.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

@implementation AbiParameterTypeFixedBytes

@synthesize type;

-(ParameterTypeFromAbi)type {
    return FixedBytes;
}

@end
