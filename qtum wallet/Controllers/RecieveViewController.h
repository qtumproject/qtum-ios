//
//  RecieveViewController.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 08.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecieveOutput.h"
#import "Presentable.h"

@interface RecieveViewController : BaseViewController <RecieveOutput, Presentable>

@property (nonatomic, weak) id<RecieveOutputDelegate> delegate;
@property (nonatomic, weak) id<Spendable> wallet;

@end
