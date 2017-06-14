//
//  NSDate+Extension.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

@property (strong, nonatomic, readonly) NSString* string;

- (NSString*)formatedDateString;


@end
