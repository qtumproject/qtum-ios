//
//  ChooseReciveAddressOutput.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 23.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChooseReciveAddressOutputDelegate.h"
#import "Presentable.h"

@protocol ChooseReciveAddressOutput <Presentable>

@property (weak, nonatomic) id <ChooseReciveAddressOutputDelegate> delegate;
@property (copy, nonatomic) NSArray <NSString*> *addresses;
@property (copy, nonatomic) NSString *prevAddress;

@end
