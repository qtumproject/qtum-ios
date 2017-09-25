//
//  TouchIDService.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 20.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TouchIDCompletionType) {
    TouchIDCanceled,
    TouchIDDenied,
    TouchIDSuccessed
};

@interface TouchIDService : NSObject

- (BOOL)hasTouchId;
- (void)checkTouchId:(void (^)(TouchIDCompletionType type))completion;

+ (instancetype)sharedInstance;
- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

@end
