//
//  DataOperation.h
//  qtum wallet
//
//  Created by Никита Федоренко on 13.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>


#define DATAHELPER_User         @"User.plist"

#define DATAHELPER_Token        @"Token.plist"

#define DATAHELPER_Home         @"Home.plist"
#define DATAHELPER_HomeBanner   @"HomeBanner.plist"

#define DATAHELPER_DynamicCount @"DynamicCount.plist"
#define DATAHELPER_Comment      @"Comment.plist"

#define DATAHELPER_SingleChat   @"SingleChat.plist"
#define DATAHELPER_GroupChat    @"GroupChat.plist"

#define DATAHELPER_GroupMeeting @"GroupMeeting.plist"

#define DATAHELPER_ChatClear    @"ChatClear.plist"

typedef void(^DeleteSuccessBlock)();
typedef void(^DeleteFailedBlock)();

@interface DataOperation : NSObject

#pragma mark - BaseMethods

+(NSMutableArray *)GetFileWithName:(NSString *)FileName;

+(NSString*)SaveFileWithName:(NSString *)FileName DataSource:(NSDictionary *)dataSource;

+(void)CreateFile:(NSString*)path fileName:(NSString*)filename;

+(BOOL)DeleteDefaultFile:(NSString*)fileName;

+(BOOL)DeleteFile:(NSString*)path success:(DeleteSuccessBlock)success failed:(DeleteFailedBlock)failed;

+(NSArray*)GetFilesName:(NSString*)path;

#pragma mark - DataMethods

+(BOOL)DataSaveDictWith:(NSMutableDictionary *)dictSave fileName:(NSString *)fileName;

+(BOOL)DataDeleteDictWithKey:(NSString *)key  KeyValue:(NSString *)keyValue fileName:(NSString *)fileName;

+(NSMutableDictionary *)DataGetDictWithKey:(NSString *)key KeyValue:(NSString *)keyValue fileName:(NSString *)fileName;

#pragma mark - SandBoxMethods

+ (NSString *)appPath;

+ (NSString *)docPath;

+ (NSString *)libPrefPath;

+ (NSString *)libCachePath;

+ (NSString *)tmpPath;

+ (BOOL)hasLive:(NSString *)path;

@end
