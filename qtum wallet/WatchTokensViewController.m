//
//  WatchTokensViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 12.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "WatchTokensViewController.h"
#import "TextFieldWithLine.h"
#import "InputTextView.h"
#import "ErrorPopUpViewController.h"

@interface WatchTokensViewController ()

@property (weak, nonatomic) IBOutlet TextFieldWithLine *contractNameField;
@property (weak, nonatomic) IBOutlet TextFieldWithLine *contractAddressTextField;
@property (weak, nonatomic) IBOutlet InputTextView *abiTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectioViewTopConstraint;

@end

@implementation WatchTokensViewController

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
}


- (void)createSmartContract {

	NSString *errorString;

	if ([SLocator.contractManager addNewTokenWithContractAddress:self.contractAddressTextField.text withAbi:self.abiTextView.text andWithName:self.contractNameField.text errorString:&errorString]) {
		[SLocator.popUpsManager showInformationPopUp:self withContent:[PopUpContentGenerator contentForTokenAdded] presenter:nil completion:nil];
	} else {
		PopUpContent *content = [PopUpContentGenerator contentForOupsPopUp];
		content.titleString = NSLocalizedString(@"Error", nil);
		content.messageString = errorString;
		ErrorPopUpViewController *vc = [SLocator.popUpsManager showErrorPopUp:self withContent:content presenter:nil completion:nil];
		[vc setOnlyCancelButton];
	}
}

@end
