//
//  RPCAdapter.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.03.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "RPCAdapter.h"

@implementation RPCAdapter

- (id)adaptiveDataForHistory:(id) data {
	return data;
}

- (id)adaptiveDataForOutputs:(id) data {

	return data;
}

- (id)adaptiveDataForBalance:(id) balance {
	return balance;
}


@end
