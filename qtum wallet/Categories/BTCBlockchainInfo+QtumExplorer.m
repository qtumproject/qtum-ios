//
//  BTCBlockchainInfo+QtumExplorer.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 02.11.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "BTCBlockchainInfo+QtumExplorer.h"
#import <objc/runtime.h>

@implementation BTCBlockchainInfo (QtumExplorer)

+ (void)load {
	static dispatch_once_t onceToken;
	dispatch_once (&onceToken, ^{
		Class class = [self class];

		SEL originalSelector1 = @selector (requestForUnspentOutputsWithAddresses:);
		SEL swizzledSelector1 = @selector (mineRequestForUnspentOutputsWithAddresses:);

		Method originalMethod1 = class_getInstanceMethod (class, originalSelector1);
		Method swizzledMethod1 = class_getInstanceMethod (class, swizzledSelector1);

		SEL originalSelector2 = @selector (requestForTransactionBroadcastWithData:);
		SEL swizzledSelector2 = @selector (mineRequestForTransactionBroadcastWithData:);

		Method originalMethod2 = class_getInstanceMethod (class, originalSelector2);
		Method swizzledMethod2 = class_getInstanceMethod (class, swizzledSelector2);

		BOOL didAddMethod1 = class_addMethod (class, originalSelector1,
				method_getImplementation (swizzledMethod1),
				method_getTypeEncoding (swizzledMethod1));

		BOOL didAddMethod2 = class_addMethod (class, originalSelector2,
				method_getImplementation (swizzledMethod2),
				method_getTypeEncoding (swizzledMethod2));

		if (didAddMethod1) {
			class_replaceMethod (class,
					swizzledSelector1,
					method_getImplementation (originalMethod1),
					method_getTypeEncoding (originalMethod1));
		} else {
			method_exchangeImplementations (originalMethod1, swizzledMethod1);
		}

		if (didAddMethod2) {
			class_replaceMethod (class,
					swizzledSelector2,
					method_getImplementation (originalMethod2),
					method_getTypeEncoding (originalMethod2));
		} else {
			method_exchangeImplementations (originalMethod2, swizzledMethod2);
		}
	});
}

#pragma mark - Mine methods

- (NSMutableURLRequest *)mineRequestForUnspentOutputsWithAddresses:(NSArray *) addresses {
	if (addresses.count == 0)
		return nil;

	NSString *urlstring = [NSString stringWithFormat:@"https://blockchain.info/unspent?active=%@", [[addresses valueForKey:@"base58String"] componentsJoinedByString:@"%7C"]];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlstring]];
	request.HTTPMethod = @"GET";
	return request;
}

- (NSMutableURLRequest *)mineRequestForTransactionBroadcastWithData:(NSData *) data {
	if (data.length == 0)
		return nil;

	NSString *urlstring = @"https://blockchain.info/pushtx";
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlstring]];
	request.HTTPMethod = @"POST";
	NSString *form = [NSString stringWithFormat:@"tx=%@", BTCHexFromData (data)];
	request.HTTPBody = [form dataUsingEncoding:NSUTF8StringEncoding];
	return request;
}

@end
