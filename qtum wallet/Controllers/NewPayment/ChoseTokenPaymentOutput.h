//
//  ChoseTokenPaymentOutput.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 04.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChoseTokenPaymentOutputDelegate;

@class Contract;

@protocol ChoseTokenPaymentOutput <NSObject>

@property (weak, nonatomic) Contract* activeToken;
@property (weak, nonatomic) id <ChoseTokenPaymentOutputDelegate> delegate;

-(void)updateWithTokens:(NSArray <Contract*>*) tokens;

@end
