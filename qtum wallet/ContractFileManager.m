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

+ (instancetype)sharedInstance {
    
    static ContractFileManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] initUniqueInstance];
    });
    return instance;
}

- (instancetype)initUniqueInstance {
    
    self = [super init];
    
    if (self != nil) {
        [self copyFilesToDocumentDirectoty];
    }
    return self;
}

-(NSString*)documentDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

-(NSString*)contractDirectory{
    return [[self documentDirectory] stringByAppendingPathComponent:@"/Contracts"];
}

-(void)copyFilesToDocumentDirectoty {
    
    NSString *fromPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Contracts"];
    NSString *contractsPath = [self contractDirectory];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:contractsPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:contractsPath withIntermediateDirectories:NO attributes:nil error:NULL];
    }
    
    NSString *toPath = contractsPath;
    [self copyAllFilesFormPath:fromPath toPath:toPath];
}

-(NSDictionary*)getAbiFromBundle {
    
    return [self getAbiFromBundleWithTemplate:@"Standart"];
}

-(NSDictionary*)getAbiFromBundleWithTemplate:(NSString*) templateName {
    
    NSString* path = [NSString stringWithFormat:@"%@/%@/abi-contract",[self contractDirectory],templateName];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary* jsonAbi = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return jsonAbi;
}

-(NSString*)getContractFromBundleWithTemplate:(NSString*) templateName {
    
    NSString* path = [NSString stringWithFormat:@"%@/%@/source-contract",[self contractDirectory],templateName];
    NSString *contract = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return contract;
}

-(NSData*)getBitcodeFromBundleWithTemplate:(NSString*) templateName {
    
    NSString* path = [NSString stringWithFormat:@"%@/%@/bitecode-contract",[self contractDirectory],templateName];
    NSString *contract = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData *bitecode = [NSString dataFromHexString:contract];
    return bitecode;
}

-(void)copyAllFilesFormPath:(NSString*) fromPath toPath:(NSString*) toPath {
    
    NSArray* resContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fromPath error:NULL];
    [resContents enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
         NSError* error;
        BOOL isDirectory;
        if (![[NSFileManager defaultManager] fileExistsAtPath:[toPath stringByAppendingPathComponent:obj] isDirectory:&isDirectory]) {
            
            [[NSFileManager defaultManager] copyItemAtPath:[fromPath stringByAppendingPathComponent:obj]
                                                    toPath:[toPath stringByAppendingPathComponent:obj]
                                                     error:&error];
        }
    }];
}

-(NSDate*)getDateOfCreationTemplate:(NSString*) templateName {
    
    NSString* path = [NSString stringWithFormat:@"%@/%@",[self contractDirectory],templateName];
    NSArray* resContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    
    NSFileManager* fm = [NSFileManager defaultManager];
    NSDictionary* attrs = [fm attributesOfItemAtPath:[path stringByAppendingPathComponent:resContents[0]] error:nil];
    
    if (attrs) {
        
        return (NSDate*)[attrs objectForKey: NSFileCreationDate];
    } else {
        
        return nil;
    }
}


-(NSArray<TemplateModel*>*)getAvailebaleTemplates {
    
    TemplateModel* standartToken = [[TemplateModel alloc] initWithTemplateName:@"Standart" andType:TokenType];
    TemplateModel* v1Token = [[TemplateModel alloc] initWithTemplateName:@"Version1" andType:TokenType];
    TemplateModel* v2Token = [[TemplateModel alloc] initWithTemplateName:@"Version2" andType:TokenType];
    TemplateModel* crowdsale = [[TemplateModel alloc] initWithTemplateName:@"Crowdsale" andType:CrowdsaleType];

    return @[standartToken,v1Token,v2Token,crowdsale];
}

@end
