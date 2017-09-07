//
//  TransactionScriptBuilder.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 06.09.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "TransactionScriptBuilder.h"

@implementation TransactionScriptBuilder


-(BTCScript*)createContractScriptWithBiteCode:(NSData*) bitcode {
    
    BTCScript* script = [[BTCScript alloc] init];
    
    uint32_t ver = 4;
    [script appendData:[NSData dataWithBytes:&ver length:4]];
    
    NSUInteger gasLimit = 2000000;
    [script appendData:[NSData dataWithBytes:&gasLimit length:8]];
    
    NSUInteger gasPrice = 1;
    [script appendData:[NSData dataWithBytes:&gasPrice length:8]];
    
    [script appendData:bitcode];
    
    [script appendOpcode:0xc1];
    
    return script;
}

-(BTCScript*)sendContractScriptWithBiteCode:(NSData*) bitcode andContractAddress:(NSData*) address {
    
    BTCScript* script = [[BTCScript alloc] init];
    
    uint32_t ver = 4;
    [script appendData:[NSData dataWithBytes:&ver length:4]];
    
    NSUInteger gasLimit = 2000000;
    [script appendData:[NSData dataWithBytes:&gasLimit length:8]];
    
    NSUInteger gasPrice = 1;
    [script appendData:[NSData dataWithBytes:&gasPrice length:8]];
    
    [script appendData:bitcode];
    
    [script appendData:address];
    
    [script appendOpcode:0xc2];
    
    return script;
}

@end
