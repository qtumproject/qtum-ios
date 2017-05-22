//
//  AbiIntephaseItem.h
//  qtum wallet
//
//  Created by Никита Федоренко on 17.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbiInterfaceOutput.h"
#import "AbiinterfaceInput.h"


typedef NS_ENUM(NSInteger, AbiItemType){
    Function,
    Constructor,
    Fallback,
    Undefined
};

@interface AbiinterfaceItem : NSObject

@property (copy, nonatomic, readonly) NSString* name;
@property (assign, nonatomic, readonly) BOOL constant;
@property (assign, nonatomic, readonly) BOOL payable;
@property (assign, nonatomic, readonly) AbiItemType type;
@property (strong, nonatomic, readonly) NSArray<AbiinterfaceInput*>* inputs;
@property (strong, nonatomic, readonly) NSArray<AbiInterfaceOutput*>* outputs;

-(instancetype)initWithObject:(id) object;

@end
