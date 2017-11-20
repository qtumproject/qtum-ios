//
//  QStoreContractOutput.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QStoreContractOutputDelegate.h"

@class QStoreContractElement;
@class QStoreBuyRequest;

@protocol QStoreContractOutput <NSObject>

@property (weak, nonatomic) id<QStoreContractOutputDelegate> delegate;

@property (strong, nonatomic) QStoreBuyRequest* buyRequest;

- (void)startLoading;
- (void)stopLoading;
- (void)setContract:(QStoreContractElement *)element;
- (void)updateWithFull;
- (void)didLoadAbi;
- (void)showSourceCode:(NSString*) source;


- (void)showContractBoughtPop;
- (void)showErrorPopUpWithMessage:(NSString *)message;

@end
