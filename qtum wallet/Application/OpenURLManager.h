//
//  OpenURLManager.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 05.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenURLManager : NSObject <Clearable>

- (void)storeAuthToYesWithAdddress:(NSString *)address;
- (void)launchFromUrl:(NSURL*)url;
- (void)clear;

@end
