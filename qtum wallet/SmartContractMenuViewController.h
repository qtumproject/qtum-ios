//
//  SmartContractMenuViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContractCoordinator.h"
#import "SmartContractMenuOutput.h"

@interface SmartContractMenuViewController : BaseViewController <SmartContractMenuOutput>

@property (strong, nonatomic) NSArray<NSString *> *contractTypes;

@end
