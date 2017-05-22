//
//  AbiinterfaceEntries.h
//  qtum wallet
//
//  Created by Никита Федоренко on 17.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AbiInputType) {
    UInt8Type,
    UInt256Type,
    StringType,
    BoolType
};

@interface AbiinterfaceEntries : NSObject

@property (copy, nonatomic, readonly) NSString* name;
@property (assign, nonatomic, readonly) AbiInputType type;

-(instancetype)initWithObject:(id) object;

@end
