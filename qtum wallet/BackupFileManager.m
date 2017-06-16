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

@implementation BackupFileManager

+(void)getBackupFile:(void (^)(NSDictionary *file, NSString* path, NSInteger size)) completionBlock {
    
    NSMutableDictionary* backup = @{}.mutableCopy;
    [backup setObject:[[ContractManager sharedInstance] decodeDataForBackup] forKey:kContractsKey];
    [backup setObject:[[TemplateManager sharedInstance] decodeDataForBackup] forKey:kTemplatesKey];
    [backup setObject:[[NSDate date] string] forKey:kDateCreateKey];
    [backup setObject:@"ios" forKey:kPlatformKey];
    [backup setObject:@"1.0" forKey:kFileVersionKey];
    [backup setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:kPlatformVersionKey];
    NSString* filePath = [DataOperation SaveFileWithName:@"backup.json" DataSource:backup.copy];
    NSInteger fileSize = (NSInteger)[[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
    completionBlock(backup.copy,filePath,fileSize);
}

+ (void)setBackupFileWithUrl:(NSURL*) url andOption:(BackupOption) option andCompletession:(void (^)(BOOL success)) completionBlock {
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data) {
        
        NSDictionary* backup = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        NSArray<TemplateModel*>* newTemplates = [[TemplateManager sharedInstance] encodeDataForBacup:backup[kTemplatesKey]];
        
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
        
        if (filteredArray.count > 0) {
            
            [[ContractManager sharedInstance] encodeDataForBacup:filteredArray withTemplates:newTemplates];
        }
        
        completionBlock(YES);

    } else {
        completionBlock(NO);
    }
}

@end
