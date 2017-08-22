//
//  QStoreRequestManager.h
//  qtum wallet
//
//  Created by Никита Федоренко on 22.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QStoreBuyRequest.h"

@interface QStoreRequestManager : NSObject

@property (strong, nonatomic, readonly) NSMutableArray<QStoreBuyRequest *> *buyRequests;
@property (strong, nonatomic, readonly) NSMutableArray<QStoreBuyRequest *> *confirmedBuyRequests;
@property (strong, nonatomic, readonly) NSMutableArray<QStoreBuyRequest *> *finishedBuyRequests;

- (void)addBuyRequest:(QStoreBuyRequest*) buyRequests;
- (void)confirmBuyRequest:(QStoreBuyRequest*) buyRequests;
- (void)finishBuyRequest:(QStoreBuyRequest*) buyRequests;

- (QStoreBuyRequest*)requestWithContractId:(NSString*) contractId;

@end
