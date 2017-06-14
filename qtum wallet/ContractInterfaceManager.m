//
//  ContractInterfaceManager.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 16.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "ContractInterfaceManager.h"
#import "InterfaceInputFormModel.h"
#import "ContractFileManager.h"
#import "ContractArgumentsInterpretator.h"
#import "ResultTokenInputsModel.h"
#import "AbiinterfaceItem.h"
#import "NSString+SHA3.h"
#import "NSString+Extension.h"

@implementation ContractInterfaceManager

+ (instancetype)sharedInstance {
    
    static ContractInterfaceManager *instance;
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


- (AbiinterfaceItem*)getTokenStandartTransferMethodInterface{
    
    InterfaceInputFormModel* interphase = [[InterfaceInputFormModel alloc] initWithAbi:[[ContractFileManager sharedInstance] getStandartAbi]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",@"transfer"];
    NSArray *filteredArray = [interphase.functionItems filteredArrayUsingPredicate:predicate];
    return filteredArray.firstObject;
}

- (AbiinterfaceItem*)getTokenStandartNamePropertyInterface{
    
    InterfaceInputFormModel* interphase = [[InterfaceInputFormModel alloc] initWithAbi:[[ContractFileManager sharedInstance] getStandartAbi]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",@"name"];
    NSArray *filteredArray = [interphase.propertyItems filteredArrayUsingPredicate:predicate];
    return filteredArray.firstObject;
}

- (AbiinterfaceItem*)getTokenStandartTotalSupplyPropertyInterface{
    
    InterfaceInputFormModel* interphase = [[InterfaceInputFormModel alloc] initWithAbi:[[ContractFileManager sharedInstance] getStandartAbi]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",@"totalSupply"];
    NSArray *filteredArray = [interphase.propertyItems filteredArrayUsingPredicate:predicate];
    return filteredArray.firstObject;
}

- (AbiinterfaceItem*)getTokenStandartSymbolPropertyInterface{
    
    InterfaceInputFormModel* interphase = [[InterfaceInputFormModel alloc] initWithAbi:[[ContractFileManager sharedInstance] getStandartAbi]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",@"symbol"];
    NSArray *filteredArray = [interphase.propertyItems filteredArrayUsingPredicate:predicate];
    return filteredArray.firstObject;
}


- (AbiinterfaceItem*)getTokenStandartDecimalPropertyInterface{
    
    InterfaceInputFormModel* interphase = [[InterfaceInputFormModel alloc] initWithAbi:[[ContractFileManager sharedInstance] getStandartAbi]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",@"decimals"];
    NSArray *filteredArray = [interphase.propertyItems filteredArrayUsingPredicate:predicate];
    return filteredArray.firstObject;
}

- (InterfaceInputFormModel*)getTokenInterfaceWithTemplate:(NSString*)templateName {
    
    InterfaceInputFormModel* interphase = [[InterfaceInputFormModel alloc] initWithAbi:[[ContractFileManager sharedInstance] getAbiWithTemplate:templateName]];
    return interphase;
}

- (NSData*)getTokenBitecodeWithTemplate:(NSString*)templateName andParam:(NSDictionary*) args{
    
    NSMutableData* contractSource = [[[ContractFileManager sharedInstance] getBitcodeWithTemplate:templateName] mutableCopy];
    [contractSource appendData:[ContractArgumentsInterpretator contactArgumentsFromDictionary:args]];
    return [contractSource copy];
}

- (NSData*)getTokenBitecodeWithTemplate:(NSString*)templateName andArray:(NSArray*) args{
    
    NSMutableData* contractSource = [[[ContractFileManager sharedInstance] getBitcodeWithTemplate:templateName] mutableCopy];
    [contractSource appendData:[ContractArgumentsInterpretator contactArgumentsFromArray:args]];
    return [contractSource copy];
}

- (NSString*)getStringHashOfFunction:(AbiinterfaceItem*) fuctionItem{
    
    NSMutableString* param = [NSMutableString new];
    for (int i = 0; i < fuctionItem.inputs.count; i++) {
        if (i != fuctionItem.inputs.count - 1) {
            [param appendFormat:@"%@,",fuctionItem.inputs[i].typeAsString];
        } else {
            [param appendString:fuctionItem.inputs[i].typeAsString];
        }
    }
    NSString* functionSignature = [NSString stringWithFormat:@"%@(%@)",fuctionItem.name,param];
    return [[functionSignature sha3:256] substringToIndex:8];
}

- (NSData*)getHashOfFunction:(AbiinterfaceItem*) fuctionItem {
    
    return [NSString dataFromHexString:[self getStringHashOfFunction:fuctionItem]];
}

- (NSData*)getHashOfFunction:(AbiinterfaceItem*) fuctionItem appendingParam:(NSArray*) param{
    
    NSAssert(fuctionItem.inputs.count == param.count, @"Function interface param count and param count must be equal");
    NSMutableData* hashFunction = [[self getHashOfFunction:fuctionItem] mutableCopy];
    NSMutableArray* mutableParam = [param mutableCopy];
    for (int i = 0; i < param.count; i++) {
        if (fuctionItem.inputs[i].type == AddressType && [param[i] isKindOfClass:[NSString class]]) {
            NSData* hexDataFromBase58 = [param[i] dataFromBase58];
            if (hexDataFromBase58.length == 25) {
                NSData* addressData = [hexDataFromBase58 subdataWithRange:NSMakeRange(1, 20)];
                [mutableParam replaceObjectAtIndex:i withObject:addressData];
            } else {
                return nil;
            }
        }
    }
    
    NSData* args = [ContractArgumentsInterpretator contactArgumentsFromArray:[mutableParam copy]];
    [hashFunction appendData:args];
    
    return [hashFunction copy];
}

@end
