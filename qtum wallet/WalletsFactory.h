//
//  WalletsFactory.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.04.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Wallet.h"

@interface WalletsFactory : NSObject

- (Wallet*)createNewWalletWithName:(NSString *)name pin:(NSString *)pin;
- (Wallet*)createNewWalletWithName:(NSString *)name pin:(NSString *)pin seedWords:(NSArray*) seedWords;

@end
