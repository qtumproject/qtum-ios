//
//  CreateTokenStep4ViewController.h
//  qtum wallet
//
//  Created by Никита Федоренко on 06.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateTokenCoordinatorDelegate;

@interface CreateTokenStep4ViewController : UIViewController

@property (weak,nonatomic) id <CreateTokenCoordinatorDelegate> delegate;
@property (strong, nonatomic) NSString *tokenName;
@property (strong, nonatomic) NSString *tokenSymbol;
@property (strong, nonatomic) NSString *initialSupply;
@property (strong, nonatomic) NSString *decimalNumber;
@property (strong, nonatomic) NSString *freezingOfAssets;
@property (strong, nonatomic) NSString *automaticSellingAndBuing;
@property (strong, nonatomic) NSString *autorefill;
@property (strong, nonatomic) NSString *proofOfWork;

@end
