//
//  ContractFileManager.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 16.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "ContractFileManager.h"
#import "NSData+Extension.h"
#import "NSString+Extension.h"
#import "TokenCell.h"

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


+(NSDictionary*)getAbiFromBundleWithTemplate:(NSString*) templateName{
    
    NSString* pathComponent = [NSString stringWithFormat:@"%@/abi-contract",templateName];
//    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"abi-contract"];
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:pathComponent];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary* jsonAbi = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return jsonAbi;
}

+(NSString*)getContractFromBundleWithTemplate:(NSString*) templateName{
    
    NSString* pathComponent = [NSString stringWithFormat:@"%@/source-contract",templateName];
//    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"source-contract"];
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:pathComponent];
    NSString *contract = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return contract;
}

+(NSData*)getBitcodeFromBundleWithTemplate:(NSString*) templateName{
    
    NSString* pathComponent = [NSString stringWithFormat:@"%@/bitecode-contract",templateName];
    //NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"bitecode-contract"];
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:pathComponent];
    NSString *contract = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData *bitecode = [NSString dataFromHexString:contract];
    return bitecode;
}

+(NSArray<NSString*>*)getAvailebaleTemplates{
    return @[@"Standart",@"Version1",@"Version2"];
}

@end
