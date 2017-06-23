//
//  BackupFileManager.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "BackupFileManager.h"
#import "TemplateManager.h"
#import "DataOperation.h"
#import "NSDate+Extension.h"

static NSString* kContractsKey = @"contracts";
static NSString* kTemplatesKey = @"templates";
static NSString* kDateCreateKey = @"date_create";
static NSString* kPlatformKey = @"platform";
static NSString* kFileVersionKey = @"fileVersion";
static NSString* kPlatformVersionKey = @"platformVersion";
static NSString* kBackupFileNameKey = @"backup.json";
static NSString* kCurrentPlatformValueKey = @"ios";
static NSString* kCurrentFileVersionValueKey = @"1.0";
static NSString* kTemplateUiidKey = @"template";

@implementation BackupFileManager

+(void)getBackupFile:(void (^)(NSDictionary *file, NSString* path, NSInteger size)) completionBlock {
    
    NSMutableDictionary* backup = @{}.mutableCopy;
    [backup setObject:[[ContractManager sharedInstance] decodeDataForBackup] forKey:kContractsKey];
    [backup setObject:[[TemplateManager sharedInstance] decodeDataForBackup] forKey:kTemplatesKey];
    [backup setObject:[[NSDate date] string] forKey:kDateCreateKey];
    [backup setObject:kCurrentPlatformValueKey forKey:kPlatformKey];
    [backup setObject:kCurrentFileVersionValueKey forKey:kFileVersionKey];
    [backup setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:kPlatformVersionKey];
    NSString* filePath = [DataOperation SaveFileWithName:kBackupFileNameKey DataSource:backup.copy];
    NSInteger fileSize = (NSInteger)[[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
    completionBlock(backup.copy,filePath,fileSize);
}

+ (void)getQuickInfoFileWithUrl:(NSURL*) url andOption:(BackupOption) option andCompletession:(void (^)(NSString* date, NSString* version, NSInteger contractCount, NSInteger templateCount, NSInteger tokenCount)) completionBlock {
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data) {
        
        NSString* date;
        NSString* version;
        NSInteger contractCount = 0;
        NSInteger templateCount = 0;
        NSInteger tokenCount = 0;
        
        NSDictionary* backup = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSArray* filteredArray;
        
        if (option & Templates && [backup[kTemplatesKey] isKindOfClass:[NSArray class]]) {
            
            NSArray* templates = backup[kTemplatesKey];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bytecode.length > 0 && source.length > 0"];
            templateCount = [templates filteredArrayUsingPredicate:predicate].count;
        }
        
        if ([backup[kContractsKey] isKindOfClass:[NSArray class]]) {
            
            NSArray* array = backup[kContractsKey];
            
            if (option & Tokens) {
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %@",@"token"];
                filteredArray = [array filteredArrayUsingPredicate:predicate];
                tokenCount = filteredArray.count;
            }
            if (option & Contracts) {
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type != %@",@"token"];
                filteredArray = [array filteredArrayUsingPredicate:predicate];
                contractCount = filteredArray.count;
            }
        }
        
        date = [[backup[kDateCreateKey] date] formatedDateString];
        version = backup[kFileVersionKey];
        completionBlock(date,version,contractCount,templateCount,tokenCount);
    }
}

+ (void)setBackupFileWithUrl:(NSURL*) url andOption:(BackupOption) option andCompletession:(void (^)(BOOL success)) completionBlock {
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    if (data) {
        
        NSDictionary* backup = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSArray* filteredArray;
        
        if (option & Tokens && option & Contracts) {
            
            filteredArray = backup[kContractsKey];
        } else if (option & Tokens) {
            
            NSArray* array = backup[kContractsKey];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type == %@",@"token"];
            filteredArray = [array filteredArrayUsingPredicate:predicate];
        } else if (option & Contracts) {
            
            NSArray* array = backup[kContractsKey];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type != %@",@"token"];
            filteredArray = [array filteredArrayUsingPredicate:predicate];
        }
        
        NSMutableSet* usefullTemplatesIndexes = [NSMutableSet new];
        
        for (NSDictionary* contract in filteredArray) {
            
            if ([contract[kTemplateUiidKey] isKindOfClass:[NSString class]]) {
                if ([contract[kTemplateUiidKey] integerValue]) {
                    [usefullTemplatesIndexes addObject:@([contract[kTemplateUiidKey] integerValue])];
                }
            } else if ([contract[kTemplateUiidKey] isKindOfClass:[NSNumber class]]) {
                [usefullTemplatesIndexes addObject:@([contract[kTemplateUiidKey] integerValue])];
            }
        }
        
        NSArray* templatesCondidats = [backup[kTemplatesKey] isKindOfClass:[NSArray class]] ? backup[kTemplatesKey] : @[];
        NSMutableArray* usefullTemplatesCondidats = @[].mutableCopy;
        
        for (NSNumber* templteIndex in usefullTemplatesIndexes) {
            NSInteger index = [templteIndex integerValue];
            if (templatesCondidats.count > index) {
                [usefullTemplatesCondidats addObject:templatesCondidats[index]];
            }
        }
        
        NSArray<TemplateModel*>* newTemplates = [[TemplateManager sharedInstance] encodeDataForBacup:[usefullTemplatesCondidats copy]];
        
        if (filteredArray.count > 0) {
            
            [[ContractManager sharedInstance] encodeDataForBacup:filteredArray withTemplates:newTemplates];
        }
        
        completionBlock(YES);

    } else {
        completionBlock(NO);
    }
}

@end
