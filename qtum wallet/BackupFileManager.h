//
//  BackupFileManager.h
//  qtum wallet
//
//  Created by Никита Федоренко on 13.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BackupFileManager : NSObject

+ (void)getBackupFile:(void (^)(NSDictionary *file))completionBlock;

@end
