//
//  QStoreContractOutputDelegate.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

@class QStoreContractElement;

@protocol QStoreContractOutputDelegate <NSObject>

- (void)didLoadFullContract:(QStoreContractElement *)element;
- (void)didSelectQStoreContractDetails:(QStoreContractElement *)element;
- (void)didPressedBack;
- (void)didSelectTag:(NSString *)tag;
- (void)didLoadAbi:(QStoreContractElement *)element;

@end
