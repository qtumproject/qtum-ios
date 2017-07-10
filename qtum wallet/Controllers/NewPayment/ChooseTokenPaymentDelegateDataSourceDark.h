//
//  ChooseTokenPaymentDelegateDataSourceDark.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 10.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseTokenPaymentDelegateDataSourceProtocol.h"

@protocol ChooseTokekPaymentDelegateDataSourceDelegate;

@interface ChooseTokenPaymentDelegateDataSourceDark : NSObject <ChooseTokenPaymentDelegateDataSourceProtocol>

@property (weak, nonatomic) Contract* activeToken;
@property (weak, nonatomic) id <ChooseTokekPaymentDelegateDataSourceDelegate> delegate;
@property (copy, nonatomic) NSArray <Contract*>* tokens;

@end
