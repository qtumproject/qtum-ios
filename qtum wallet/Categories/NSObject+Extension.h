//
//  NSObject+Extension.h
//  qtum wallet
//
//  Created by Никита Федоренко on 26.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Extension)

- (NSString*)nameOfClass;
- (BOOL)isNull;
- (void)setAssociatedObject:(id)associatedObjec;
- (id)associatedObject;

@end
