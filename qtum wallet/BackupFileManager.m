//
//  BackupFileManager.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NSDate+Extension.h"

static NSString* kContractsKey = @"contracts";
static NSString* kTemplatesKey = @"templates";
static NSString* kDateCreateKey = @"date_create";
static NSString* kPlatformKey = @"platform";
static NSString* kFileVersionKey = @"backup_version";
static NSString* kPlatformVersionKey = @"platform_version";
static NSString* kBackupFileNameKey = @"backup.json";
static NSString* kCurrentPlatformValueKey = @"ios";
static NSString* kCurrentFileVersionValueKey = @"1.0";
static NSString* kTemplateUuidKey = @"template";

@implementation BackupFileManager

- (void)getBackupFile:(void (^)(NSDictionary *file, NSString* path, NSInteger size)) completionBlock {
    
    NSMutableDictionary* backup = @{}.mutableCopy;
    backup[kContractsKey] = [[ContractManager sharedInstance] decodeDataForBackup];
    backup[kTemplatesKey] = [SLocator.templateManager decodeDataForBackup];
    backup[kDateCreateKey] = [[NSDate date] string];
    backup[kPlatformKey] = kCurrentPlatformValueKey;
    backup[kFileVersionKey] = kCurrentFileVersionValueKey;
    backup[kPlatformVersionKey] = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
    NSString* filePath = [SLocator.dataOperation saveFileWithName:kBackupFileNameKey dataSource:backup.copy];

    NSInteger fileSize = (NSInteger)[[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
    completionBlock(backup.copy,filePath,fileSize);
}

- (BOOL)getQuickInfoFileWithUrl:(NSURL*) url andOption:(BackupOption) option andCompletession:(void (^)(NSString* date, NSString* version, NSInteger contractCount, NSInteger templateCount, NSInteger tokenCount)) completionBlock {
    
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
        
        date = [NSDate formatedDateStringFromString:backup[kDateCreateKey]];
        version = backup[kFileVersionKey];
        completionBlock(date,version,contractCount,templateCount,tokenCount);
        
        return YES;
    }
    
    return NO;
}

- (void)setBackupFileWithUrl:(NSURL*) url andOption:(BackupOption) option andCompletession:(void (^)(BOOL success)) completionBlock {
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    BOOL processedWithoutErrors = YES;
    
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
        
        NSMutableSet* usefullTemplatesUUIDs = [NSMutableSet new];
        
        for (NSDictionary* contract in filteredArray) {
            
            if ([contract[kTemplateUuidKey] isKindOfClass:[NSString class]]) {
                [usefullTemplatesUUIDs addObject:contract[kTemplateUuidKey]];
            } else if ([contract[kTemplateUuidKey] isKindOfClass:[NSNumber class]]) {
                [usefullTemplatesUUIDs addObject:[NSString stringWithFormat:@"%@", contract[kTemplateUuidKey]]];
            }
        }
        
        NSArray* templatesCondidats = [backup[kTemplatesKey] isKindOfClass:[NSArray class]] ? backup[kTemplatesKey] : @[];
        NSMutableArray* usefullTemplatesCondidats = @[].mutableCopy;
        
        for (NSString* templteUUID in usefullTemplatesUUIDs) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uuid == %@",templteUUID];
            NSArray* filteredTemplateArray = [templatesCondidats filteredArrayUsingPredicate:predicate];
            if (filteredTemplateArray.count > 0) {
                [usefullTemplatesCondidats addObject:filteredTemplateArray.firstObject];
            }
        }
        
        NSArray<TemplateModel*>* newTemplates = [SLocator.templateManager encodeDataForBacup:[usefullTemplatesCondidats copy]];
        
        if (filteredArray.count > 0 && newTemplates.count > 0 && [[ContractManager sharedInstance] encodeDataForBacup:filteredArray withTemplates:newTemplates]) {
            
            processedWithoutErrors = YES;
        } else {
            processedWithoutErrors = NO;
        }
        

    } else {
        processedWithoutErrors = NO;
    }
    
    completionBlock(processedWithoutErrors);

}

@end
