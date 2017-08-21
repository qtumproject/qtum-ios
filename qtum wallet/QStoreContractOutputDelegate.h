//
//  QStoreContractOutputDelegate.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

@class QStoreContractElement;

@protocol QStoreContractOutputDelegate <NSObject>

- (void)didLoadViewWithFullContract:(QStoreContractElement *)element;
- (void)didLoadAbi:(QStoreContractElement *)element;

- (void)didSelectPurchaseContract:(QStoreContractElement *)element;
- (void)didSelectQStoreContractDetails:(QStoreContractElement *)element;
- (void)didSelectTag:(NSString *)tag;

- (void)didPressedBack;

@end
