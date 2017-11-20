//
//  RestoreContractsPopUpViewController.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 12.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "PopUpViewController.h"

@interface RestoreContractsPopUpViewController : PopUpViewController

@property (nonatomic, weak) id <PopUpWithTwoButtonsViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *contractsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *tokensCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *templateCounLabel;

@end
