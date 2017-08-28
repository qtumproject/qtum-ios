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
    return self;
}

-(NSArray*)getQRC20TokenStandartAbiInterface {
    
    NSString* qrc20 = @"[{\"constant\":false,\"inputs\":[{\"name\":\"_spender\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint\"}],\"name\":\"approve\",\"outputs\":[{\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"totalSupply\",\"outputs\":[{\"name\":\"totalSupply\",\"type\":\"uint\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_from\",\"type\":\"address\"},{\"name\":\"_to\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint\"}],\"name\":\"transferFrom\",\"outputs\":[{\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"_owner\",\"type\":\"address\"}],\"name\":\"balanceOf\",\"outputs\":[{\"name\":\"balance\",\"type\":\"uint\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_to\",\"type\":\"address\"},{\"name\":\"_value\",\"type\":\"uint\"}],\"name\":\"transfer\",\"outputs\":[{\"name\":\"success\",\"type\":\"bool\"}],\"payable\":false,\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"_owner\",\"type\":\"address\"},{\"name\":\"_spender\",\"type\":\"address\"}],\"name\":\"allowance\",\"outputs\":[{\"name\":\"remaining\",\"type\":\"uint\"}],\"payable\":false,\"type\":\"function\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"_from\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"_to\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"_value\",\"type\":\"uint\"}],\"name\":\"Transfer\",\"type\":\"event\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":true,\"name\":\"_owner\",\"type\":\"address\"},{\"indexed\":true,\"name\":\"_spender\",\"type\":\"address\"},{\"indexed\":false,\"name\":\"_value\",\"type\":\"uint\"}],\"name\":\"Approval\",\"type\":\"event\"}]";
    
    NSError* error;
    NSArray *jsonAbi = [self arrayFromAbiString:qrc20];
    NSAssert(!error, @"Serialization of standart erc 20 token failed");
    return jsonAbi;
}

-(NSArray*)arrayFromAbiString:(NSString*) abiString {
    
    NSError* error;
    NSArray *jsonAbi = [NSJSONSerialization JSONObjectWithData:[abiString dataUsingEncoding:NSUTF8StringEncoding]
                                                       options:NSJSONReadingMutableContainers
                                                         error:&error];
    return jsonAbi;
}

- (AbiinterfaceItem*)tokenStandartTransferMethodInterface{
    
    InterfaceInputFormModel* interphase = [[InterfaceInputFormModel alloc] initWithAbi:[[ContractFileManager sharedInstance] standartAbi]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",@"transfer"];
    NSArray *filteredArray = [interphase.functionItems filteredArrayUsingPredicate:predicate];
    return filteredArray.firstObject;
}

- (AbiinterfaceItem*)tokenStandartNamePropertyInterface{
    
    InterfaceInputFormModel* interphase = [[InterfaceInputFormModel alloc] initWithAbi:[[ContractFileManager sharedInstance] standartAbi]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",@"name"];
    NSArray *filteredArray = [interphase.propertyItems filteredArrayUsingPredicate:predicate];
    return filteredArray.firstObject;
}

- (AbiinterfaceItem*)tokenStandartTotalSupplyPropertyInterface{
    
    InterfaceInputFormModel* interphase = [[InterfaceInputFormModel alloc] initWithAbi:[[ContractFileManager sharedInstance] standartAbi]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",@"totalSupply"];
    NSArray *filteredArray = [interphase.propertyItems filteredArrayUsingPredicate:predicate];
    return filteredArray.firstObject;
}

- (AbiinterfaceItem*)tokenStandartSymbolPropertyInterface{
    
    InterfaceInputFormModel* interphase = [[InterfaceInputFormModel alloc] initWithAbi:[[ContractFileManager sharedInstance] standartAbi]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",@"symbol"];
    NSArray *filteredArray = [interphase.propertyItems filteredArrayUsingPredicate:predicate];
    return filteredArray.firstObject;
}


- (AbiinterfaceItem*)tokenStandartDecimalPropertyInterface{
    
    InterfaceInputFormModel* interphase = [[InterfaceInputFormModel alloc] initWithAbi:[[ContractFileManager sharedInstance] standartAbi]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@",@"decimals"];
    NSArray *filteredArray = [interphase.propertyItems filteredArrayUsingPredicate:predicate];
    return filteredArray.firstObject;
}

- (InterfaceInputFormModel*)tokenInterfaceWithTemplate:(NSString*)templatePath {
    
    InterfaceInputFormModel* interphase = [[InterfaceInputFormModel alloc] initWithAbi:[[ContractFileManager sharedInstance] abiWithTemplate:templatePath]];
    return interphase;
}

- (InterfaceInputFormModel*)tokenQRC20Interface{
    
    InterfaceInputFormModel* interphase = [[InterfaceInputFormModel alloc] initWithAbi:[self getQRC20TokenStandartAbiInterface]];
    return interphase;
}

- (NSData*)tokenBitecodeWithTemplate:(NSString*)templatePath andParam:(NSDictionary*) args{
    
    NSMutableData* contractSource = [[[ContractFileManager sharedInstance] bitcodeWithTemplate:templatePath] mutableCopy];
    [contractSource appendData:[ContractArgumentsInterpretator contactArgumentsFromDictionary:args]];
    return [contractSource copy];
}

- (NSData*)tokenBitecodeWithTemplate:(NSString*)templatePath andArray:(NSArray*) args{
    
    NSMutableData* contractSource = [[[ContractFileManager sharedInstance] bitcodeWithTemplate:templatePath] mutableCopy];
    
    [contractSource appendData:[ContractArgumentsInterpretator contactArgumentsFromArray:args]];
    return [contractSource copy];
}

- (NSString*)stringHashOfFunction:(AbiinterfaceItem*) fuctionItem{
    
    NSMutableString* param = [NSMutableString new];
    for (int i = 0; i < fuctionItem.inputs.count; i++) {
        if (i != fuctionItem.inputs.count - 1) {
            [param appendFormat:@"%@,",fuctionItem.inputs[i].typeAsString];
        } else {
            [param appendString:fuctionItem.inputs[i].typeAsString];
        }
    }
    NSString* functionSignature = [NSString stringWithFormat:@"%@(%@)",fuctionItem.name,param];
    return [[functionSignature sha3:SHA3256] substringToIndex:8];
}

- (NSData*)hashOfFunction:(AbiinterfaceItem*) fuctionItem {
    
    return [NSString dataFromHexString:[self stringHashOfFunction:fuctionItem]];
}

- (NSData*)hashOfFunction:(AbiinterfaceItem*) fuctionItem appendingParam:(NSArray*) param{
    
    NSAssert(fuctionItem.inputs.count == param.count, @"Function interface param count and param count must be equal");
    NSMutableData* hashFunction = [[self hashOfFunction:fuctionItem] mutableCopy];
    NSMutableArray* mutableParam = [param mutableCopy];
    
    //creating hex data from string paremeter
    for (int i = 0; i < param.count; i++) {
        if (fuctionItem.inputs[i].type == AddressType && [param[i] isKindOfClass:[NSString class]]) {
            NSData* hexDataFromBase58 = [param[i] dataFromBase58];
            if (hexDataFromBase58.length == 25) {
                NSData* addressData = [hexDataFromBase58 subdataWithRange:NSMakeRange(1, 20)];
                mutableParam[i] = addressData;
            } else {
                return nil;
            }
        }
    }
    
    NSData* args = [ContractArgumentsInterpretator contactArgumentsFromArray:[mutableParam copy]];
    [hashFunction appendData:args];
    
    return [hashFunction copy];
}

- (BOOL)isERCTokenStandartInterface:(NSArray*) interface {
    
    NSArray* qrc20interface = [self getQRC20TokenStandartAbiInterface];
    return [self isInterfaceArray:interface equalQRC20InterfaceArray:qrc20interface];
}

- (BOOL)isERCTokenStandartAbiString:(NSString*) abiString {
    
    //replascing string brcause in standart uint256 and uint is equal
    NSArray* interface = [self arrayFromAbiString:[abiString stringByReplacingOccurrencesOfString:@"uint256" withString:@"uint"]];
    NSArray* qrc20interface = [self getQRC20TokenStandartAbiInterface];
    return [self isInterfaceArray:interface equalQRC20InterfaceArray:qrc20interface];
}

-(BOOL)isInterfaceArray:(NSArray*)intefaceArray equalQRC20InterfaceArray:(NSArray*)qrc20 {
    
    BOOL isSubset = [[NSSet setWithArray: qrc20] isSubsetOfSet: [NSSet setWithArray: intefaceArray]];
    return isSubset;
}

@end
