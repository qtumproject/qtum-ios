//
//  AddressTransferPopupViewController.h
//  qtum wallet
//
//  Created by Никита Федоренко on 02.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "PopUpViewController.h"

@interface AddressTransferPopupViewController : PopUpViewController

@property (nonatomic, weak) id<PopUpWithTwoButtonsViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString* toAddress;
@property (nonatomic, copy) NSArray<NSString*>* fromAddressesVariants;
@property (nonatomic, copy) NSString* fromAddress;
@property (nonatomic, copy) NSString* amount;

@end
