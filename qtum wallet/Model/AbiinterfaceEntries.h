//
//  AbiinterfaceEntries.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbiParameterProtocol.h"
#import "AbiTypesProcessor.h"

@interface AbiinterfaceEntries : NSObject

@property (copy, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) id <AbiParameterProtocol> type;
@property (copy, nonatomic, readonly) NSString *typeAsString;

- (instancetype)initWithObject:(id) object;

@end
