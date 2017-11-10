//
//  SmartContractsListViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublishedContractListOutputDelegate.h"
#import "PublishedContractListOutput.h"
#import "RemoveContractTrainigView.h"

@interface SmartContractsListViewController : BaseViewController <PublishedContractListOutput>

@property (weak, nonatomic) RemoveContractTrainigView *trainingView;

@end
