//
//  RestoreContractsViewController.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 12.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestoreContractsOutput.h"
#import "CheckboxButton.h"

@interface RestoreContractsViewController : UIViewController <RestoreContractsOutput, CheckboxButtonDelegate>

@property (strong, nonatomic) NSMutableArray <CheckboxButton *> *buttons;
@property (weak, nonatomic) IBOutlet UIView *containerForButtons;

@end
