//
//  ConfirmPopUpViewController.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 03.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "PopUpViewController.h"

@interface ConfirmPopUpViewController : PopUpViewController

@property (nonatomic, weak) id<PopUpWithTwoButtonsViewControllerDelegate> delegate;

@end
