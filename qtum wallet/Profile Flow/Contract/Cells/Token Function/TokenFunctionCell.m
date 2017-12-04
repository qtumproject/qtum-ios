//
//  TokenFunctionCell.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "TokenFunctionCell.h"

@implementation TokenFunctionCell

- (void)setupWithObject:(AbiinterfaceItem *) object {
    
    if (object.type == Fallback) {
        self.functionName.text = NSLocalizedString(@"Send to contract", @"");
    } else {
        self.functionName.text = object.name;
    }
}

@end
