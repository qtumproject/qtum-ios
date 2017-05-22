//
//  NewPaymentViewController.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.11.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPaymentViewController : BaseViewController

@property (nonatomic, copy) NSString *currentBalance;
@property (nonatomic, copy) NSDictionary *dictionary;

-(void)setAdress:(NSString*)adress andValue:(NSString*)amount;

@end
