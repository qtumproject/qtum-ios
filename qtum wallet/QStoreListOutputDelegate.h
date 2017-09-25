//
//  QStoreListOutputDelegate.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 10.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

@class QStoreCategory;
@class QStoreContractElement;

@protocol QStoreListOutputDelegate <NSObject>

- (void)didSelectQStoreCategory:(QStoreCategory *)category;
- (void)didSelectQStoreContract:(QStoreContractElement *)element;
- (void)didPressedBack;

@end
