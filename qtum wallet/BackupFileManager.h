//
//  BackupFileManager.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackupFileManager : NSObject

+(void)getBackupFile:(void (^)(NSDictionary *file, NSString* path, NSInteger size)) completionBlock;

@end
