//
//  ShareTokenPopUpViewController.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 14.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "PopUpViewController.h"

@interface ShareTokenPopUpViewController : PopUpViewController

@property (nonatomic) NSString *addressString;
@property (weak, nonatomic) IBOutlet UITextView *abiTextView;
@property (nonatomic) NSString *abiString;

@property (nonatomic, weak) id<ShareTokenPopupViewControllerDelegate> delegate;

@end
