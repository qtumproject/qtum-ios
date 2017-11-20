//
//  TokensFactory.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.04.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

@interface TokensFactory ()

@end

@implementation TokensFactory

+ (instancetype)sharedInstance {

	static TokensFactory *instance;
	static dispatch_once_t onceToken;
	dispatch_once (&onceToken, ^{
		instance = [[super alloc] initUniqueInstance];
	});
	return instance;
}

- (instancetype)initUniqueInstance {
	self = [super init];
	if (self != nil) {
	}
	return self;
}

@end
