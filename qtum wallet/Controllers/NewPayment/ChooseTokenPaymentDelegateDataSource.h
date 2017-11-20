//
//  ChooseTokenPaymentDelegateDataSource.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 13.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChooseTokenPaymentDelegateDataSourceProtocol.h"

@protocol ChooseTokekPaymentDelegateDataSourceDelegate;

@interface ChooseTokenPaymentDelegateDataSource : NSObject <ChooseTokenPaymentDelegateDataSourceProtocol>

@property (weak, nonatomic) Contract* activeToken;
@property (weak, nonatomic) id <ChooseTokekPaymentDelegateDataSourceDelegate> delegate;
@property (copy, nonatomic) NSArray <Contract*>* tokens;

@end
