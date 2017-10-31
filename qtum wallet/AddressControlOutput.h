//
//  AddressControlOutput.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 02.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressControlOutputDelegate.h"
#import "Presentable.h"
#import "BTCKey.h"

@protocol AddressControlOutput <Presentable>

@property (weak, nonatomic) id <AddressControlOutputDelegate> delegate;
@property (copy, nonatomic) NSDictionary <NSString*, NSDictionary<NSString*,NSString*>*>* addressesValueHashTable;

-(void)reloadData;

@end
