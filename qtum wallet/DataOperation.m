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

- (NSString *)getStringFormFileWithName:(NSString *) fileName {

	NSString *stringPath = [self docPath];
	NSString *stringFile = [stringPath stringByAppendingPathComponent:fileName];

	NSString *stringSource = [[NSString alloc] initWithContentsOfFile:stringFile encoding:NSUTF8StringEncoding error:NULL];
	return stringSource;
}

- (NSString *)saveGroupFileWithName:(NSString *) fileName dataSource:(NSDictionary *) dataSource {

	NSString *stringPath = [self groupPath];
	NSString *stringFile = [stringPath stringByAppendingPathComponent:fileName];

	NSError *err;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dataSource options:0 error:&err];
	[jsonData writeToFile:stringFile atomically:YES];

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

- (void)createFile:(NSString *) path fileName:(NSString *) filename {

	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager changeCurrentDirectoryPath:[path stringByExpandingTildeInPath]];
	[fileManager createFileAtPath:filename contents:nil attributes:nil];
}

- (BOOL)deleteDefaultFile:(NSString *) fileName {

	@try {
		NSFileManager *fileManager = [NSFileManager defaultManager];

		NSString *stringPath = [self docPath];
		NSString *stringFile = [stringPath stringByAppendingPathComponent:fileName];

		[fileManager changeCurrentDirectoryPath:[stringPath stringByExpandingTildeInPath]];
		[fileManager removeItemAtPath:stringFile error:nil];

		return YES;
	}
	@catch (NSException *exception) {
		return NO;
	}
	@finally {

	}
}

- (BOOL)deleteFile:(NSString *) path success:(deleteSuccessBlock) success failed:(deleteFailedBlock) failed {

	@try {
		NSFileManager *fileManager = [NSFileManager defaultManager];

		[fileManager changeCurrentDirectoryPath:[path stringByExpandingTildeInPath]];
		[fileManager removeItemAtPath:path error:nil];
		if (success) {
			success ();
		}

		return YES;
	}
	@catch (NSException *exception) {
		return NO;
	}
	@finally {
		if (failed) {
			failed ();
		}
	}
}

- (NSArray *)getFilesName:(NSString *) path {

	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *files = [fileManager subpathsAtPath:path];
	return files;
}

#pragma mark - DataMethods


- (void)dataAppendString:(NSString *) string toFileWithName:(NSString *) fileName {

	NSString *stringPath = [self docPath];
	NSString *stringFile = [stringPath stringByAppendingPathComponent:fileName];

	NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:stringFile];

	if (fileHandle) {

		[fileHandle seekToEndOfFile];
		[fileHandle writeData:[string dataUsingEncoding:NSUTF8StringEncoding]];
		[fileHandle closeFile];
	} else {

		[string writeToFile:stringFile
				 atomically:NO
				   encoding:NSStringEncodingConversionAllowLossy
					  error:nil];
	}
}

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

- (BOOL)hasLiveDirectory:(NSString *) path {
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {

		return [[NSFileManager defaultManager] createDirectoryAtPath:path
										 withIntermediateDirectories:YES
														  attributes:nil
															   error:NULL];
	}

	return NO;
}

- (void)hasLiveFileWithPath:(NSString *) path {

	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:path]) {
		[fileManager changeCurrentDirectoryPath:[path stringByExpandingTildeInPath]];
		[fileManager createFileAtPath:path contents:nil attributes:nil];
	}
}

@end
