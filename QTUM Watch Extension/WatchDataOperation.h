//
//  WatchDataOperation.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 14.09.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WatchDataOperation : NSObject

extern NSString *const groupFileName;

+ (NSDictionary *)getDictFormGroupFileWithName:(NSString *)fileName;
+ (NSString*)saveGroupFileWithName:(NSString *)fileName dataSource:(NSDictionary *)dataSource;
+ (void)saveWalletInfo:(NSDictionary*) walletInfo;
+ (NSDictionary*)getWalletInfo;

@end
