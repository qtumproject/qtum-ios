//
//  NSObject+Associating.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 21.05.17.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Associating)

- (BOOL)isNull;

@property (nonatomic, retain) id associatedObject;

@end
