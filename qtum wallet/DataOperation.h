//
//  DataOperation.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const groupFileName;
extern NSString *const newsCacheFileName;

typedef void(^deleteSuccessBlock)(void);
typedef void(^deleteFailedBlock)(void);

@interface DataOperation : NSObject

#pragma mark - BaseMethods

- (NSDictionary *)getDictFormFileWithName:(NSString *)fileName;
- (NSData *)getDataFormFileWithName:(NSString *)fileName;
- (NSDictionary *)getDictFormGroupFileWithName:(NSString *)fileName;
- (NSString*)saveFileWithName:(NSString *)fileName dataSource:(NSDictionary *)dataSource;
- (NSString*)saveFileWithName:(NSString *)fileName withData:(NSData *)data;
- (NSString*)saveGroupFileWithName:(NSString *)fileName dataSource:(NSDictionary *)dataSource;
- (NSString*)addGropFileWithName:(NSString *)fileName dataSource:(NSDictionary *)dataSource;
- (NSString*)deleteGroupFileWithName:(NSString *)fileName valueForKey:(NSString *)key;

#pragma mark - SandBoxMethods

- (NSString *)appPath;
- (NSString *)docPath;
- (NSString *)libPrefPath;
- (NSString *)libCachePath;
- (NSString *)tmpPath;

@end
