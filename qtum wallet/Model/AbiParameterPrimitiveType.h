//
//  AbiParameterPrimitiveType.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbiParameterProtocol.h"

@interface AbiParameterPrimitiveType : NSObject <AbiParameterProtocol>

@property (assign, nonatomic) NSInteger size;
@property (assign, nonatomic, readonly) NSInteger maxValue;

- (instancetype)initWithSize:(NSUInteger) size;

@end
