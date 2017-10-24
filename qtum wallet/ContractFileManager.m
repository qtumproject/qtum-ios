//
//  ContractFileManager.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 16.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ContractFileManager.h"
#import "NSData+Extension.h"
#import "NSString+Extension.h"
#import "TokenCell.h"
#import "TemplateManager.h"
#import "ServiceLocator.h"

@implementation ContractFileManager

- (instancetype)init {
    
    self = [super init];
    
    if (self != nil) {
        [self copyFilesToDocumentDirectoty];
    }
    return self;
}

-(NSString*)documentDirectory{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
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

-(NSArray*)standartAbi {
    
    return [self abiWithTemplate:[SLocator.templateManager standartTokenTemplate].path];
}

-(NSArray*)abiWithTemplate:(NSString*) templatePath {
    
    NSString* path = [NSString stringWithFormat:@"%@/%@/abi-contract",[self contractDirectory],templatePath];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray* jsonAbi = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    return jsonAbi;
}

-(NSString*)escapeAbiWithTemplate:(NSString*) templatePath {
    
    NSString* path = [NSString stringWithFormat:@"%@/%@/abi-contract",[self contractDirectory],templatePath];
    NSString *abi = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return abi;
}

-(NSString*)contractWithTemplate:(NSString*) templatePath {
    
    NSString* path = [NSString stringWithFormat:@"%@/%@/source-contract",[self contractDirectory],templatePath];
    NSString *contract = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    return contract;
}

-(NSData*)bitcodeWithTemplate:(NSString*) templatePath {
    
    NSString* path = [NSString stringWithFormat:@"%@/%@/bitecode-contract",[self contractDirectory], templatePath];
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

-(BOOL)writeNewAbi:(NSArray*) abi withPathName:(NSString*) templatePath {
    
    if (![abi isKindOfClass:[NSArray class]]) {
        return NO;
    }
    
    NSString* folderPath = [NSString stringWithFormat:@"%@/%@",[self contractDirectory], templatePath];
    NSString* filePath = [NSString stringWithFormat:@"%@/abi-contract",folderPath];

    
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:NULL];
    }
    
    NSError *err = nil;
    
    NSMutableData *jsonData = [[NSJSONSerialization dataWithJSONObject:abi
                                                               options:0 
                                                                 error:&err] copy];
    [jsonData writeToFile:filePath atomically:YES];
    
    return err ? NO : YES;
}

-(BOOL)writeNewBitecode:(NSString*) bitecode withPathName:(NSString*) templatePath {
    
    NSString* folderPath = [NSString stringWithFormat:@"%@/%@",[self contractDirectory],templatePath];
    NSString* filePath = [NSString stringWithFormat:@"%@/bitecode-contract",folderPath];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:NULL];
    }
    
    NSError *err = nil;
    
    [bitecode writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    
    return err ? NO : YES;
}

-(BOOL)writeNewSource:(NSString*) source withPathName:(NSString*) path {
    
    NSString* folderPath = [NSString stringWithFormat:@"%@/%@",[self contractDirectory],path];
    NSString* filePath = [NSString stringWithFormat:@"%@/source-contract",folderPath];
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:folderPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:NULL];
    }
    
    NSError *err = nil;
    
    [source writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    
    return err ? NO : YES;
}

-(NSDate*)dateOfCreationTemplate:(NSString*) templatePath {
    
    NSString* path = [NSString stringWithFormat:@"%@/%@",[self contractDirectory],templatePath];
    NSArray* resContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    
    NSFileManager* fm = [NSFileManager defaultManager];
    NSDictionary* attrs = [fm attributesOfItemAtPath:[path stringByAppendingPathComponent:resContents[0]] error:nil];
    
    return attrs ? (NSDate*)attrs[NSFileCreationDate] : nil;
}


@end
