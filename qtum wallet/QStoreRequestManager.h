//
//  QStoreRequestManager.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 22.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QStoreBuyRequest.h"
#import "QStoreContractElement.h"

@interface QStoreRequestManager : NSObject <NSCoding>

@property (strong, nonatomic, readonly) NSMutableArray<QStoreBuyRequest *> *buyRequests;
@property (strong, nonatomic, readonly) NSMutableArray<QStoreBuyRequest *> *confirmedBuyRequests;
@property (strong, nonatomic, readonly) NSMutableArray<QStoreBuyRequest *> *finishedBuyRequests;

- (void)addBuyRequest:(QStoreBuyRequest*) buyRequests completion:(void(^)(void)) completion;
- (void)confirmBuyRequest:(QStoreBuyRequest*) buyRequests completion:(void(^)(void)) completion;
- (void)finishBuyRequest:(QStoreBuyRequest*) buyRequests completion:(void(^)(void)) completion;

- (QStoreBuyRequest*)requestWithContractId:(NSString*) contractId;
- (QStoreBuyRequest *)requestByElement:(QStoreContractElement *)element;

@end
