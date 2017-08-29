//
//  AbiinterfaceEntries.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AbiInputType) {
    UInt8Type,
    UInt256Type,
    StringType,
    BytesType,
    AddressType,
    BytesStaticType32,
    BoolType
};

@interface AbiinterfaceEntries : NSObject

@property (copy, nonatomic, readonly) NSString* name;
@property (assign, nonatomic, readonly) AbiInputType type;
@property (assign, nonatomic, readonly) NSString* typeAsString;


-(instancetype)initWithObject:(id) object;

@end
