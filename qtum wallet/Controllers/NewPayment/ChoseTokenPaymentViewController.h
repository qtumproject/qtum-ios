//
//  ChoseTokenPaymentViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 25.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoseTokenPaymentOutput.h"
#import "ChoseTokenPaymentOutputDelegate.h"
#import "Presentable.h"
#import "ChooseTokenPaymentDelegateDataSourceProtocol.h"

@interface ChoseTokenPaymentViewController : BaseViewController <ChoseTokenPaymentOutput, Presentable>

@property (strong, nonatomic) id <ChooseTokenPaymentDelegateDataSourceProtocol> delegateDataSource;
@property (weak, nonatomic) id <ChoseTokenPaymentOutputDelegate> delegate;

@end
