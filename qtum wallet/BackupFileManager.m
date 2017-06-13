//
//  BackupFileManager.m
//  qtum wallet
//
//  Created by Никита Федоренко on 13.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "BackupFileManager.h"
#import "TemplateManager.h"

@implementation BackupFileManager

+(void)getBackupFile:(void (^)(NSDictionary *file))completionBlock {
    NSMutableDictionary* backup = @{}.mutableCopy;
    [backup setObject:[[ContractManager sharedInstance] backupDescription] forKey:@"contrats"];
    [backup setObject:[[TemplateManager sharedInstance] backupDescription] forKey:@"templates"];
    [backup setObject:[NSDate date] forKey:@"date_create"];
    [backup setObject:@"ios" forKey:@"platform"];
    [backup setObject:@"1.0" forKey:@"fileVersion"];
    [backup setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"platformVersion"];
    completionBlock(backup.copy);
}

@end
