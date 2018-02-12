//
//  WalletBalanceFacadeService.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 08.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WalletBalanceHendler)(BOOL succes);

@interface WalletBalanceFacadeService : NSObject

- (instancetype)initWithRequestService:(id <Requestable>) requestManager andStorageService:(CoreDataService*) storageService;

- (QTUMBigNumber*)lastBalance;
- (QTUMBigNumber*)lastUnconfirmedBalance;
- (NSString*)lastUpdateDateSring;

- (void)updateForAddreses:(NSArray *) keyAddreses withHandler:(WalletBalanceHendler) handler;
- (void)updateBalansesWithObject:(NSDictionary *) dataDictionary withHandler:(WalletBalanceHendler) handler;

@end
