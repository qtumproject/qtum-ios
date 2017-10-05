//
//  RequestManager.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 20.05.17.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Requestable.h"

extern NSString *const TCAAuthFailed;

@interface RequestManager : NSObject <Requestable>

- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

@end
