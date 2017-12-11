//
//  DataOperation.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

NSString *const groupFileName = @"group";
NSString *const newsCacheFileName = @"newsCashFile";

@implementation DataOperation

#pragma mark - BaseMethods

- (NSMutableArray *)getDictFormFileWithName:(NSString *) fileName {

	NSString *stringPath = [self docPath];
	NSString *stringFile = [stringPath stringByAppendingPathComponent:fileName];

	NSData *data = [NSData dataWithContentsOfFile:stringFile];
	if (data) {
		return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
	}
	return nil;
}

- (NSData *)getDataFormFileWithName:(NSString *) fileName {

	NSString *stringPath = [self docPath];
	NSString *stringFile = [stringPath stringByAppendingPathComponent:fileName];

	NSData *data = [NSData dataWithContentsOfFile:stringFile];
	return data;
}

- (NSDictionary *)getDictFormGroupFileWithName:(NSString *) fileName {

	NSString *stringPath = [self groupPath];
	NSString *stringFile = [stringPath stringByAppendingPathComponent:fileName];

	NSData *data = [NSData dataWithContentsOfFile:stringFile];
	if (data) {
		return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
	}
	return nil;
}

- (NSString *)saveGroupFileWithName:(NSString *) fileName dataSource:(NSDictionary *) dataSource {

	NSString *stringPath = [self groupPath];
	NSString *stringFile = [stringPath stringByAppendingPathComponent:fileName];

	NSError *err;
    if (dataSource) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataSource options:0 error:&err];
        [jsonData writeToFile:stringFile atomically:YES];
    }

	return stringFile;
}

- (NSString *)saveFileWithName:(NSString *) fileName dataSource:(NSDictionary *) dataSource {

	NSString *stringPath = [self docPath];
	NSString *stringFile = [stringPath stringByAppendingPathComponent:fileName];

	NSError *err;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataSource options:0 error:&err];
	NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

	[json writeToFile:stringFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];

	return stringFile;
}

- (NSString *)saveFileWithName:(NSString *) fileName withData:(NSData *) data {

	NSString *stringPath = [self docPath];
	NSString *stringFile = [stringPath stringByAppendingPathComponent:fileName];

	NSData *jsonData = data;

	[jsonData writeToFile:stringFile atomically:YES];

	return stringFile;
}

- (NSString *)addGropFileWithName:(NSString *) fileName dataSource:(NSDictionary *) dataSource {

	NSDictionary *groupInfo = [self getDictFormGroupFileWithName:fileName];
	NSMutableDictionary *summ;

	if (groupInfo) {
		summ = [groupInfo mutableCopy];
		[summ addEntriesFromDictionary:dataSource];
	} else {
		summ = [dataSource mutableCopy];
	}
	return [self saveGroupFileWithName:fileName dataSource:[summ copy]];
}

- (NSString *)deleteGroupFileWithName:(NSString *) fileName valueForKey:(NSString *) key {

	NSDictionary *groupInfo = [self getDictFormGroupFileWithName:fileName];
	NSMutableDictionary *summ;

	if (groupInfo) {
		summ = [groupInfo mutableCopy];
		[summ removeObjectForKey:key];
    }

	return [self saveGroupFileWithName:fileName dataSource:[summ copy]];
}

#pragma mark - DataMethods

#pragma mark - SandBoxMethods

- (NSString *)appPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains (NSApplicationDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

- (NSString *)docPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

- (NSString *)libPrefPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains (NSLibraryDirectory, NSUserDomainMask, YES);
	return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Preference"];
}

- (NSString *)libCachePath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains (NSLibraryDirectory, NSUserDomainMask, YES);
	return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
}

- (NSString *)tmpPath {
	NSArray *paths = NSSearchPathForDirectoriesInDomains (NSLibraryDirectory, NSUserDomainMask, YES);
	return [[paths objectAtIndex:0] stringByAppendingFormat:@"/tmp"];
}

- (NSString *)groupPath {
	NSString *appGroupDirectoryPath = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.org.qtum.qtum-wallet"].path;
	return appGroupDirectoryPath;
}


@end
