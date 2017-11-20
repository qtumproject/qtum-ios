//
//  RPCAdapter.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.03.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPCAdapter : NSObject <RequestManagerAdapter>

- (id)adaptiveDataForHistory:(id) data;

- (id)adaptiveDataForOutputs:(id) data;

@end
