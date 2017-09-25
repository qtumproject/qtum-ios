//
//  AddressTransferPopupViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 02.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "PopUpViewController.h"
#import "NSNumber+Comparison.h"
#import "NSNumber+Format.h"

@interface AddressTransferPopupViewController : PopUpViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) id<PopUpWithTwoButtonsViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString* toAddress;
@property (nonatomic, copy) NSDictionary<NSString*, NSNumber*>* fromAddressesVariants;
@property (nonatomic, copy) NSString* fromAddress;
@property (nonatomic, copy) NSString* amount;

- (void)endEditing;

@end
