//
//  QStoreContractOutput.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreContractOutputDelegate.h"

@class QStoreFullContractElement;

@protocol QStoreContractOutput <NSObject>

@property (weak, nonatomic) id<QStoreContractOutputDelegate> delegate;

- (void)startLoading;
- (void)stopLoading;
- (void)setShortContract:(QStoreShortContractElement *)element;
- (void)setFullContract:(QStoreFullContractElement *)element;

@end
