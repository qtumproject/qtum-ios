//
//  NSOperationQueue+Timeout.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 01.12.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NSOperationQueue+Timeout.h"

@implementation NSOperationQueue (Timeout)

- (NSOperation *)addOperationWithBlock:(void (^)(NSOperation *operation))block timeout:(CGFloat)timeout
                          timeoutBlock:(void (^)(void))timeoutBlock {
    
    NSBlockOperation *blockOperation = [[NSBlockOperation alloc] init];  // create operation
    NSBlockOperation __weak *weakOperation = blockOperation;             // prevent strong reference cycle
    
    // add call to caller's provided block, passing it a reference to this `operation`
    // so the caller can check to see if the operation was canceled (i.e. if it timed out)
    
    [blockOperation addExecutionBlock:^{
        block(weakOperation);
    }];
    
    // add the operation to this queue
    
    [self addOperation:blockOperation];
    
    // if unfinished after `timeout`, cancel it and call `timeoutBlock`
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // if still in existence, and unfinished, then cancel it and call `timeoutBlock`
        
        if (weakOperation && ![weakOperation isFinished]) {
            [weakOperation cancel];
            if (timeoutBlock) {
                timeoutBlock();
            }
        }
    });
    
    return blockOperation;
}

@end
