//
//  TokenAddressLibraryOutput.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TokenAddressLibraryOutputDelegate.h"
#import "Presentable.h"

@class ContracBalancesObject;

@protocol TokenAddressLibraryOutput <Presentable>

@property (weak, nonatomic) id <TokenAddressLibraryOutputDelegate> delegate;
@property (copy, nonatomic) NSString* symbol;
@property (copy, nonatomic) NSArray <ContracBalancesObject*>* arrayWithAddressesAndBalances;

-(void)reloadData;

@end
