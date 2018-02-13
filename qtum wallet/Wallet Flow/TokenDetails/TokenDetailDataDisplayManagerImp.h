//
//  TokenDetailDataDisplayManagerImp.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 12.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TokenDetailDataDisplayManager.h"

@interface TokenDetailDataDisplayManagerImp : NSObject <TokenDetailDataDisplayManager>

- (id<HistoryElementProtocol>)elementForIndexPath:(NSIndexPath*) indexPath;
- (NSInteger)countOfHistoryElement;
- (void)didPressedHistoryElementAtIndexPath:(NSIndexPath*) indexPath;

@end
