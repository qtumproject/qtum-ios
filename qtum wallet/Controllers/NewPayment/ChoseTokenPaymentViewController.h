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

@interface ChoseTokenPaymentViewController : BaseViewController <ChoseTokenPaymentOutput, Presentable>

@property (copy, nonatomic) NSArray <Contract*>* tokens;
@property (weak, nonatomic) Contract* activeToken;
@property (weak, nonatomic) id <ChoseTokenPaymentOutputDelegate> delegate;

@end
