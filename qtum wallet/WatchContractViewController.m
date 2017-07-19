//
//  WatchContractViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 09.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "WatchContractViewController.h"
#import "TextFieldWithLine.h"
#import "InputTextView.h"
#import "ContractFileManager.h"
#import "FavouriteTemplatesCollectionSource.h"

@interface WatchContractViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet TextFieldWithLine *contractNameField;
@property (weak, nonatomic) IBOutlet TextFieldWithLine *contractAddressTextField;
@property (weak, nonatomic) IBOutlet InputTextView *abiTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraintForCollectionView;

@end

@implementation WatchContractViewController

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
    [[PopUpsManager sharedInstance] dismissLoader];
    if ([[ContractManager sharedInstance] addNewContractWithContractAddress:self.contractAddressTextField.text withAbi:self.abiTextView.text andWithName:self.contractNameField.text]) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Done", "")];
        [self.delegate didPressedBack];
    } else {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Error", "")];
    }
}

- (void)done:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - Actions and Piblic

- (IBAction)didPressedBackAction:(id)sender {
    [self.delegate didPressedBack];
}

- (IBAction)didPressedOkAction:(id)sender {
    [[PopUpsManager sharedInstance] showLoaderPopUp];
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
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    
    [self.delegate didChangeAbiText];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.contentSize.width - 1, self.scrollView.contentSize.height - 1, 1, 1) animated:YES];
}

@end
