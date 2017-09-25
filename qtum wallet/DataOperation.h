//
//  DataOperation.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kWSSLogFileName;

typedef void(^deleteSuccessBlock)();
typedef void(^deleteFailedBlock)();

@interface DataOperation : NSObject

#pragma mark - BaseMethods

+ (NSMutableArray *)getArrayFormFileWithName:(NSString *)fileName;
+ (NSString *)getStringFormFileWithName:(NSString *)fileName;
+ (NSDictionary *)getDictFormGroupFileWithName:(NSString *)fileName;
+ (NSString*)saveFileWithName:(NSString *)fileName dataSource:(NSDictionary *)dataSource;
+ (NSString*)saveGroupFileWithName:(NSString *)fileName dataSource:(NSDictionary *)dataSource;
+ (NSString*)addGropFileWithName:(NSString *)fileName dataSource:(NSDictionary *)dataSource;
+ (void)createFile:(NSString*)path fileName:(NSString*)filename;
+ (BOOL)deleteDefaultFile:(NSString*)fileName;
+ (BOOL)deleteFile:(NSString*)path success:(deleteSuccessBlock)success failed:(deleteFailedBlock)failed;
+ (NSArray*)getFilesName:(NSString*)path;

#pragma mark - DataMethods

+ (BOOL)dataSaveDictWith:(NSDictionary *)dictSave fileName:(NSString *)fileName;
+ (BOOL)dataDeleteDictWithKey:(NSString *)key  keyValue:(NSString *)keyValue fileName:(NSString *)fileName;
+ (NSDictionary *)dataGetDictWithKey:(NSString *)key keyValue:(NSString *)keyValue fileName:(NSString *)fileName;
+ (void)dataAppendString:(NSString*) string toFileWithName:(NSString*) fileName;

#pragma mark - SandBoxMethods

+ (NSString *)appPath;
+ (NSString *)docPath;
+ (NSString *)libPrefPath;
+ (NSString *)libCachePath;
+ (NSString *)tmpPath;
+ (BOOL)hasLiveDirectory:(NSString *)path;

@end
