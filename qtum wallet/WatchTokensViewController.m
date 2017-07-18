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

@interface WatchTokensViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet TextFieldWithLine *contractNameField;
@property (weak, nonatomic) IBOutlet TextFieldWithLine *contractAddressTextField;
@property (weak, nonatomic) IBOutlet ImputTextView *abiTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation WatchTokensViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self.collectionSource;
    self.collectionView.delegate = self.collectionSource;
    self.collectionSource.collectionView = self.collectionView;
    
    self.abiTextView.delegate = self;
    
    [self addDoneButtonToTextInputs];
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
    
    if ([[ContractManager sharedInstance] addNewTokenWithContractAddress:self.contractAddressTextField.text withAbi:self.abiTextView.text andWithName:self.contractNameField.text]) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Done", "")];
        [self.delegate didPressedBack];
    } else {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Error", "")];
    }
}

- (IBAction)didPressedBackAction:(id)sender {
    [self.delegate didPressedBack];
}

- (IBAction)didPressedOkAction:(id)sender {
    [SVProgressHUD show];
    [self createSmartContract];
}

- (IBAction)didPressedCancelAction:(id)sender {
    [self.delegate didPressedBack];
}

- (void)done:(id)sender {
    [self.view endEditing:YES];
}

- (void)textViewDidChange:(UITextView *)textView {
    
    [self.delegate didChangeAbiText];
}

- (IBAction)chooseFromLibraryButtonPressed:(id)sender {
    
    [self.delegate didSelectChooseFromLibrary:self];
}

- (void)changeStateForSelectedTemplate:(TemplateModel *)templateModel {

    self.abiTextView.text = templateModel ? [[ContractFileManager sharedInstance] escapeAbiWithTemplate:templateModel.path]: @"";
    [self.abiTextView setContentOffset:CGPointZero];
}

@end
