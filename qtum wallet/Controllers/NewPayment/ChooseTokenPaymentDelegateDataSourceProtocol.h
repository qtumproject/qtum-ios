//
//  ChooseTokenPaymentDelegateDataSourceProtocol.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 10.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChooseTokekPaymentDelegateDataSourceDelegate;

@class Contract;

@protocol ChooseTokenPaymentDelegateDataSourceProtocol <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) Contract *activeToken;
@property (weak, nonatomic) id <ChooseTokekPaymentDelegateDataSourceDelegate> delegate;
@property (copy, nonatomic) NSArray <Contract *> *tokens;

@end
