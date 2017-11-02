//
//  AbiParameterPrimitiveType.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbiParameterProtocol.h"

@interface AbiParameterPrimitiveType : NSObject <AbiParameterProtocol>

@property (assign, nonatomic) NSInteger size;
@property (assign, nonatomic, readonly) NSInteger maxValue;
@property (assign, nonatomic, readonly) NSInteger maxValueLenght;


- (instancetype)initWithSize:(NSUInteger) size;

@end
