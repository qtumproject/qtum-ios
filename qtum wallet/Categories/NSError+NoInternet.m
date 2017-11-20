//
//  NSError+NoInternet.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 03.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

@implementation NSError (NoInternet)

- (BOOL)isNoInternetConnectionError
{
    return ([self.domain isEqualToString:NSURLErrorDomain] && (self.code == NSURLErrorNotConnectedToInternet));
}

@end
