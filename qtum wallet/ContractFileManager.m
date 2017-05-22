//
//  ContractFileManager.m
//  qtum wallet
//
//  Created by Никита Федоренко on 16.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "ContractFileManager.h"
#import "NSData+Extension.h"
#import "NSString+Extension.h"

@implementation ContractFileManager

+(NSDictionary*)getAbiFromBundle{
    
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"abi-contract"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary* jsonAbi = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return jsonAbi;
}

+(NSString*)getContractFromBundle{
    
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"source-contract"];
    NSString *contract = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return contract;
}

+(NSData*)getBitcodeFromBundle{
    
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"bitecode-contract"];
    NSString *contract = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData *bitecode = [NSString dataFromHexString:contract];
    return bitecode;
}

@end
