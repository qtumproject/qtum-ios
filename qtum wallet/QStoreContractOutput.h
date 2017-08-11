//
//  QStoreContractOutput.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreContractOutputDelegate.h"

@class QStoreContractElement;

@protocol QStoreContractOutput <NSObject>

@property (weak, nonatomic) id<QStoreContractOutputDelegate> delegate;

- (void)startLoading;
- (void)stopLoading;
- (void)setContract:(QStoreContractElement *)element;
- (void)updateWithFull;
- (void)showAbi;

@end
