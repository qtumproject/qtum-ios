//
//  BackupFileManager.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSInteger, BackupOption) {
    Templates       = (1 << 0),
    Contracts       = (1 << 1),
    Tokens          = (1 << 2),
};

@interface BackupFileManager : NSObject

+(void)getBackupFile:(void (^)(NSDictionary *file, NSString* path, NSInteger size)) completionBlock;
+(void)setBackupFileWithUrl:(NSURL*) url andOption:(BackupOption) option andCompletession:(void (^)(BOOL success)) completionBlock;
+(BOOL)getQuickInfoFileWithUrl:(NSURL*) url andOption:(BackupOption) option andCompletession:(void (^)(NSString* date, NSString* version, NSInteger contractCount, NSInteger templateCount, NSInteger tokenCount)) completionBlock;

@end
