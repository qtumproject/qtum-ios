//
//  TokenModel.m
//  qtum wallet
//
//  Created by Никита Федоренко on 18.04.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "TokenModel.h"

@implementation TokenModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _type = Tokenable;
    }
    return self;
}

@end
