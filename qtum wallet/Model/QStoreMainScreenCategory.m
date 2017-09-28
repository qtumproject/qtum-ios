//
//  QStoreCategory.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QStoreMainScreenCategory.h"
#import "QStoreContractElement.h"

@interface QStoreMainScreenCategory()

@property (nonatomic) NSString *urlPath;

@end

@implementation QStoreMainScreenCategory

- (instancetype)initWithIdentifier:(NSString *)identifier
                              name:(NSString *)name
                           urlPath:(NSString *)urlPath {
    
    self = [super initWithIdentifier:identifier name:name count:@(0)];
    if (self) {
        _urlPath = urlPath;
    }
    return self;
}

@end
