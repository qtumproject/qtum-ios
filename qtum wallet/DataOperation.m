//
//  DataOperation.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "DataOperation.h"

@implementation DataOperation

#pragma mark - BaseMethods

+(NSMutableArray *)GetFileWithName:(NSString *)FileName {

    NSArray *arrayPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    if ([arrayPath count] <= 0) {
        return nil;
    }
    NSString *stringPath = [arrayPath objectAtIndex:0];
    NSString *stringFile=[stringPath stringByAppendingPathComponent:FileName];
    

    NSMutableArray *arraySource = [[NSMutableArray alloc] initWithContentsOfFile:stringFile];
    return arraySource;
}


+ (NSString*)SaveFileWithName:(NSString *)FileName DataSource:(NSDictionary *)dataSource {

    NSArray *arrayPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    if ([arrayPath count] <= 0) {
        return nil;
    }
    
    NSString *stringPath = [arrayPath objectAtIndex:0];
    NSString *stringFile = [stringPath stringByAppendingPathComponent:FileName];
    
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dataSource options:0 error:&err];
    NSString * json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    [json writeToFile:stringFile atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    return stringFile;
}


+(void)CreateFile:(NSString*)path fileName:(NSString*)filename
{

    NSFileManager *fileManager = [NSFileManager defaultManager];

    [fileManager changeCurrentDirectoryPath:[path stringByExpandingTildeInPath]];

    [fileManager createFileAtPath:filename contents:nil attributes:nil];
}


+(BOOL)DeleteDefaultFile:(NSString*)fileName{
    @try {

        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *arrayPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        if ([arrayPath count] <= 0) {
            return NO;
        }
        
        NSString *stringPath = [arrayPath objectAtIndex:0];
        NSString *stringFile=[stringPath stringByAppendingPathComponent:fileName];

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


+(BOOL)DeleteFile:(NSString*)path success:(DeleteSuccessBlock)success failed:(DeleteFailedBlock)failed
{
    @try {

        NSFileManager *fileManager = [NSFileManager defaultManager];

        [fileManager changeCurrentDirectoryPath:[path stringByExpandingTildeInPath]];

        [fileManager removeItemAtPath:path error:nil];
        if (success) {
            success();
        }
        
        return YES;
    }
    @catch (NSException *exception) {
        return NO;
    }
    @finally {
        if (failed) {
            failed();
        }
    }
}


+(NSArray*)GetFilesName:(NSString*)path
{

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [fileManager subpathsAtPath: path ];
    return  files;
}

#pragma mark - DataMethods

+(BOOL)DataSaveDictWith:(NSMutableDictionary *)dictSave fileName:(NSString *)fileName {
    NSMutableArray *arraySource = [DataOperation GetFileWithName:fileName];
    if (arraySource == nil) {
        arraySource = [[NSMutableArray alloc] init];
    }
    
    if (![arraySource containsObject:dictSave]) {
        [arraySource addObject:dictSave];
    }else {
        return NO;
    }
    [DataOperation SaveFileWithName:fileName DataSource:arraySource];
    return YES;
}


+(BOOL)DataDeleteDictWithKey:(NSString *)key  KeyValue:(NSString *)keyValue fileName:(NSString *)fileName {
    NSMutableArray *arraySource = [DataOperation GetFileWithName:fileName];
    if (arraySource == nil) {
        arraySource = [[NSMutableArray alloc] init];
    }
    
    for (NSMutableDictionary *dictSub in arraySource) {
        if ([[dictSub objectForKey:key] isEqualToString:keyValue]) {
            [arraySource removeObject:dictSub];
            break;
        }
    }
    [DataOperation SaveFileWithName:fileName DataSource:arraySource];
    return YES;
}


+(NSMutableDictionary *)DataGetDictWithKey:(NSString *)key KeyValue:(NSString *)keyValue fileName:(NSString *)fileName {
    NSMutableArray *arraySource = [DataOperation GetFileWithName:fileName];
    if (arraySource == nil) {
        arraySource = [[NSMutableArray alloc] init];
    }
    for (NSMutableDictionary *dictSub in arraySource) {
        if ([[dictSub objectForKey:key] isEqualToString:keyValue]) {
            return dictSub;
        }
    }
    return nil;
}

#pragma mark - SandBoxMethods

+ (NSString *)appPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

+ (NSString *)docPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	return [paths objectAtIndex:0];
}

+ (NSString *)libPrefPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Preference"];
}

+ (NSString *)libCachePath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	return [[paths objectAtIndex:0] stringByAppendingFormat:@"/Caches"];
}

+ (NSString *)tmpPath
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	return [[paths objectAtIndex:0] stringByAppendingFormat:@"/tmp"];
}

+ (BOOL)hasLive:(NSString *)path
{
	if ( NO == [[NSFileManager defaultManager] fileExistsAtPath:path] )
	{
		return [[NSFileManager defaultManager] createDirectoryAtPath:path
										 withIntermediateDirectories:YES
														  attributes:nil
															   error:NULL];
	}
	
	return NO;
}

@end
