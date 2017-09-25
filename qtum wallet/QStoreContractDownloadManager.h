//
//  QStoreContractDownloadManager.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 22.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QStoreDataProvider.h"
#import "QStoreBuyRequest.h"

@interface QStoreContractDownloadManager : NSObject

- (instancetype)initWithDataProvider:(QStoreDataProvider*) dataProvider;
- (void)downloadContractWithRequest:(QStoreBuyRequest*) request completion:(void(^)(BOOL success,QStoreBuyRequest *request)) completion;

@end
