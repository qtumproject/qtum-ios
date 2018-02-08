//
//  ValueRepresentationEntity.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 08.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventLogHeader.h"

@interface ValueRepresentationEntity : NSObject

@property (assign, nonatomic) ConvertionAddressType type;

- (instancetype)initWithHexString:(NSString*) hex;

- (NSString*)valueDependsOnType;
- (NSString*)nameDependsOnType;

@end
