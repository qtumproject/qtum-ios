//
//  WatchTokensViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 12.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "WatchTokensViewController.h"
#import "TextFieldWithLine.h"
#import "ImputTextView.h"
#import "ContractFileManager.h"
#import "FavouriteTemplatesCollectionSource.h"
#import "ErrorPopUpViewController.h"

@interface WatchTokensViewController () <UITextViewDelegate, UITextFieldDelegate, PopUpWithTwoButtonsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet TextFieldWithLine *contractNameField;
@property (weak, nonatomic) IBOutlet TextFieldWithLine *contractAddressTextField;
@property (weak, nonatomic) IBOutlet ImputTextView *abiTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraintForCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *okButton;

@end

@implementation WatchTokensViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self.collectionSource;
    self.collectionView.delegate = self.collectionSource;
    self.collectionSource.collectionView = self.collectionView;
    
    self.abiTextView.delegate = self;
    
    [self addDoneButtonToTextInputs];
    
    if (IS_IPHONE_5) {
        self.collectionView.hidden = YES;
        self.bottomConstraintForCollectionView.constant = -10.0f;
    }
    
    [self.contractNameField addTarget:self action:@selector(updateOkButton) forControlEvents:UIControlEventEditingChanged];
    [self.contractAddressTextField addTarget:self action:@selector(updateOkButton) forControlEvents:UIControlEventEditingChanged];
    
    [self updateOkButton];
}

#pragma mark - Private Methods

- (void)addDoneButtonToTextInputs {
    
    UIToolbar* toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    toolbar.barStyle = UIBarStyleDefault;
    toolbar.translucent = NO;
    toolbar.barTintColor = customBlackColor();
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", "") style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
    doneItem.tintColor = customBlueColor();
    toolbar.items = @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneItem];
    [toolbar sizeToFit];
    
    self.contractNameField.inputAccessoryView = toolbar;
    self.contractAddressTextField.inputAccessoryView = toolbar;
    self.abiTextView.inputAccessoryView = toolbar;
}

-(void)createSmartContract {
    
    NSString *errorString;
    if ([[ContractManager sharedInstance] addNewTokenWithContractAddress:self.contractAddressTextField.text withAbi:self.abiTextView.text andWithName:self.contractNameField.text errorString:&errorString]) {
        [[PopUpsManager sharedInstance] showInformationPopUp:self withContent:[PopUpContentGenerator contentForTokenAdded] presenter:nil completion:nil];
    } else {
        PopUpContent *content = [PopUpContentGenerator contentForOupsPopUp];
        content.titleString = NSLocalizedString(@"Error", nil);
        content.messageString = errorString;
        ErrorPopUpViewController *vc = [[PopUpsManager sharedInstance] showErrorPopUp:self withContent:content presenter:nil completion:nil];
        [vc setOnlyCancelButton];
    }
}

- (void)done:(id)sender {
    [self.view endEditing:YES];
}

- (void)updateOkButton {
    
    BOOL available = (self.abiTextView.text.length > 0) && (self.contractNameField.text.length > 0) && (self.contractAddressTextField.text.length > 0);
    self.okButton.enabled = available;
    self.okButton.alpha = available ? 1.0f : 0.7f;
}

#pragma mark - PopUpWithTwoButtonsViewControllerDelegate

- (void)okButtonPressed:(PopUpViewController *)sender {
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
    
    if (![sender isKindOfClass:[ErrorPopUpViewController class]]) {
        self.contractNameField.text = @"";
        self.abiTextView.text = @"";
        self.contractAddressTextField.text = @"";
        [self.delegate didChangeAbiText];
        [self updateOkButton];
    }
}

- (void)cancelButtonPressed:(PopUpViewController *)sender {
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
}

#pragma mark - Actions and Public

- (IBAction)didPressedBackAction:(id)sender {
    [self.delegate didPressedBack];
}

- (IBAction)didPressedOkAction:(id)sender {
    [self createSmartContract];
}

- (IBAction)didPressedCancelAction:(id)sender {
    [self.delegate didPressedBack];
}

- (IBAction)chooseFromLibraryButtonPressed:(id)sender {
    
    [self.delegate didSelectChooseFromLibrary:self];
}

- (void)changeStateForSelectedTemplate:(TemplateModel *)templateModel {

    self.abiTextView.text = templateModel ? [[ContractFileManager sharedInstance] escapeAbiWithTemplate:templateModel.path]: @"";
    [self.abiTextView setContentOffset:CGPointZero];
    [self updateOkButton];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    
    [self.delegate didChangeAbiText];
    [self updateOkButton];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.contentSize.width - 1, self.scrollView.contentSize.height - 1, 1, 1) animated:YES];
}

@end
