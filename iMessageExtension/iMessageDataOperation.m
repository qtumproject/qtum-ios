//
//  iMessageDataOperation.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 14.09.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "iMessageDataOperation.h"

@implementation iMessageDataOperation

+(NSDictionary *)getDictFormGroupFileWithName:(NSString *)fileName {
    
    NSString *stringPath = [[self class] groupPath];
    NSString *stringFile = [stringPath stringByAppendingPathComponent:fileName];
    
    NSData *data = [NSData dataWithContentsOfFile:stringFile];
    if (data) {
        return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    }
    return nil;
}

+(NSString*)saveGroupFileWithName:(NSString *)fileName dataSource:(NSDictionary *)dataSource {
    
    NSString *stringPath = [[self class] groupPath];
    NSString *stringFile = [stringPath stringByAppendingPathComponent:fileName];
    
    NSError * err;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dataSource options:0 error:&err];
    [jsonData writeToFile:stringFile atomically:YES];
    
    return stringFile;
}

+ (NSString *)groupPath {
    
    NSString *appGroupDirectoryPath = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.org.qtum.qtum-wallet"].path;
    return appGroupDirectoryPath;
}

@end
