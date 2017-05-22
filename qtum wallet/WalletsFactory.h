//
//  WalletsFactory.h
//  qtum wallet
//
//  Created by Никита Федоренко on 19.04.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WalletsFactory : NSObject

+ (instancetype)sharedInstance;
- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

- (Wallet*)createNewWalletWithName:(NSString *)name pin:(NSString *)pin;
- (Wallet*)createNewWalletWithName:(NSString *)name pin:(NSString *)pin seedWords:(NSArray*) seedWords;

@end
