//
//  QStoreCategory.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QStoreCategory.h"

@class QStoreContractElement;

@interface QStoreMainScreenCategory : QStoreCategory

@property (nonatomic, readonly) NSString *urlPath;

- (instancetype)initWithIdentifier:(NSString *)identifier
                              name:(NSString *)name
                           urlPath:(NSString *)urlPath;

@end
