//
//  RecieveViewController.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 08.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecieveViewController : BaseViewController

@property (nonatomic, weak) id <Spendable> wallet;

@end
