//
//  ChoseTokenPaymentOutputDelegate.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 04.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChoseTokenPaymentOutputDelegate <NSObject>

@required
- (void)didPressedBackAction;

@end
