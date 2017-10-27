//
//  Cancelable.h
//  qtum wallet
//
//  Created by Никита Федоренко on 27.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Cancelable <NSObject>

-(void)cancel;

@end
