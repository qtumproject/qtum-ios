//
//  BTCTransactionOutput+Address.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.04.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "BTCTransactionOutput+Address.h"
#import <objc/runtime.h>

NSString const *keyOut = @"org.qtum.output.extension";

@implementation BTCTransactionOutput (Address)

- (void)setRunTimeAddress:(NSString *) runTimeAddress {

	objc_setAssociatedObject (self, &keyOut, runTimeAddress, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)runTimeAddress {

	return objc_getAssociatedObject (self, &keyOut);
}

@end
