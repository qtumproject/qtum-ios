//
//  SourceCodePopUpViewController.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 27.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopUpViewController.h"

@interface SourceCodePopUpViewController : PopUpViewController

@property (nonatomic, weak) id<PopUpWithTwoButtonsViewControllerDelegate> delegate;

@end
