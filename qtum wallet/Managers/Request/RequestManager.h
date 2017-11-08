//
//  RequestManager.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 20.05.17.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Requestable.h"

extern NSString *const TCAAuthFailed;

@interface RequestManager : NSObject <Requestable>

@end
