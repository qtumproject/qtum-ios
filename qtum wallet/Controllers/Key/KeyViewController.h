//
//  PublicKeyViewController.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 23.11.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyViewController : BaseViewController

@property (nonatomic) BTCKey *key;
@property (nonatomic) BOOL isPrivate;

@end
