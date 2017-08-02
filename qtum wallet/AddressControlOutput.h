//
//  AddressControlOutput.h
//  qtum wallet
//
//  Created by Никита Федоренко on 02.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressControlOutputDelegate.h"
#import "Presentable.h"
#import "BTCKey.h"

@protocol AddressControlOutput <Presentable>

@property (weak, nonatomic) id <AddressControlOutputDelegate> delegate;
@property (copy, nonatomic) NSArray <BTCKey*>* addresses;

@end
