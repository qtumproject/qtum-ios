//
//  ConfirmPurchasePopUpViewController.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 28.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopUpViewController.h"

@interface ConfirmPurchasePopUpViewController : PopUpViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contractNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contractTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *minterAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (nonatomic, weak) id <PopUpWithTwoButtonsViewControllerDelegate> delegate;

@end
