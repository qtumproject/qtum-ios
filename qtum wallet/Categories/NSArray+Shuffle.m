//
//  NSArray (Shuffle)
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NSArray+Shuffle.h"

@implementation NSArray (Shuffle)

- (NSArray *)shuffledArray {
    
    NSMutableArray *shuffledArray = [self mutableCopy];
    NSUInteger arrayCount = [shuffledArray count];
    
    for (uint32_t i = (uint32_t)(arrayCount - 1); i > 0; i--) {
        NSUInteger n = arc4random_uniform(i + 1);
        [shuffledArray exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    return [shuffledArray copy];
}

- (NSArray *)shuffledArrayWithItemLimit:(NSUInteger)itemLimit {
    
    if (!itemLimit) return [self shuffledArray];
    
    NSMutableArray *shuffledArray = [self mutableCopy];
    NSUInteger arrayCount = [shuffledArray count];
    
    NSUInteger loopCounter = 0;
    for (uint32_t i = (uint32_t)(arrayCount - 1); i > 0 && loopCounter < itemLimit; i--) {
        NSUInteger n = (NSUInteger)arc4random_uniform(i + 1);
        [shuffledArray exchangeObjectAtIndex:i withObjectAtIndex:n];
        loopCounter++;
    }
    
    NSArray *arrayWithLimit;
    if (arrayCount > itemLimit) {
        NSRange arraySlice = NSMakeRange(arrayCount - loopCounter, loopCounter);
        arrayWithLimit = [shuffledArray subarrayWithRange:arraySlice];
    } else
        arrayWithLimit = [shuffledArray copy];
    
    return arrayWithLimit;
}

@end
