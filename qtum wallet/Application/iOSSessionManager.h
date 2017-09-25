//
//  iOSSessionManager.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 06.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface iOSSessionManager : NSObject

+ (instancetype)sharedInstance;

- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

- (void)sendMessage:(NSString *)message;

@end
