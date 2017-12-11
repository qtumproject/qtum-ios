//
//  KeychainStorage.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 29.11.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeychainKeyValueStorageProtocol.h"

@interface KeychainStorage : NSObject <KeychainKeyValueStorageProtocol>

@end
