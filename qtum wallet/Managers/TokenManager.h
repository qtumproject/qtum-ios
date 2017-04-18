//
//  TokenManager.h
//  qtum wallet
//
//  Created by Никита Федоренко on 12.04.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HistoryElement;

@interface TokenManager : NSObject

+ (instancetype)sharedInstance;
- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

-(void)checkSmartContract:(HistoryElement*) item;
-(void)addSmartContractPretendent:(NSArray*) addresses forKey:(NSString*) key;

@end