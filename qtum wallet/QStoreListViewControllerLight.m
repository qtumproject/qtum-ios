//
//  QStoreListViewControllerLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QStoreListViewControllerLight.h"
#import "QStoreListTableSourceLight.h"

@interface QStoreListViewControllerLight ()

@end

@implementation QStoreListViewControllerLight

@synthesize source = _source;

-(QStoreListTableSource*)source {
    
    if (!_source) {
        _source = [QStoreListTableSourceLight new];
    }
    return _source;
}

@end
