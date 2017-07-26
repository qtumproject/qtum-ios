//
//  TokenDetailOutputDelegate.h
//  qtum wallet
//
//  Created by Никита Федоренко on 24.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Spendable.h"

@protocol TokenDetailOutputDelegate <NSObject>

- (void)showAddressInfoWithSpendable:(id <Spendable>) spendable;
- (void)didBackPressed;
- (void)didShareTokenButtonPressed;

@end
