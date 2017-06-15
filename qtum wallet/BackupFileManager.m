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
    [backup setObject:[[ContractManager sharedInstance] backupDescription] forKey:kContractsKey];
    [backup setObject:[[TemplateManager sharedInstance] backupDescription] forKey:kTemplatesKey];
    [backup setObject:[[NSDate date] string] forKey:kDateCreateKey];
    [backup setObject:@"ios" forKey:kPlatformKey];
    [backup setObject:@"1.0" forKey:kFileVersionKey];
    [backup setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:kPlatformVersionKey];
    NSString* filePath = [DataOperation SaveFileWithName:@"backup.json" DataSource:backup.copy];
    NSInteger fileSize = (NSInteger)[[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
    completionBlock(backup.copy,filePath,fileSize);
}

@end
