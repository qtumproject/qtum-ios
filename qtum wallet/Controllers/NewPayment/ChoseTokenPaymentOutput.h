//
//  ChoseTokenPaymentOutput.h
//  qtum wallet
//
//  Created by Никита Федоренко on 04.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChoseTokenPaymentOutputDelegate;
@protocol ChooseTokenPaymentDelegateDataSourceProtocol;

@class Contract;

@protocol ChoseTokenPaymentOutput <NSObject>

@property (weak, nonatomic) id <ChoseTokenPaymentOutputDelegate> delegate;
@property (strong, nonatomic) id <ChooseTokenPaymentDelegateDataSourceProtocol> delegateDataSource;

-(void)updateWithTokens:(NSArray <Contract*>*) tokens;

@end
