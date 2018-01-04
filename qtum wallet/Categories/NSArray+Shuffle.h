//
//  NSArray (Shuffle)
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Shuffle)

- (NSArray *)shuffledArray;
- (NSArray *)shuffledArrayWithItemLimit:(NSUInteger)itemLimit;

@end
