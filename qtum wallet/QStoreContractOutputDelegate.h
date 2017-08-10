//
//  QStoreContractOutputDelegate.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

@class QStoreShortContractElement;
@class QStoreFullContractElement;

@protocol QStoreContractOutputDelegate <NSObject>

- (void)didLoadFullContract:(QStoreShortContractElement *)element;
- (void)didSelectQStoreContractDetails:(QStoreFullContractElement *)element;
- (void)didPressedBack;
- (void)didSelectTag:(NSString *)tag;
- (void)didLoadAbi:(QStoreFullContractElement *)element;

@end
