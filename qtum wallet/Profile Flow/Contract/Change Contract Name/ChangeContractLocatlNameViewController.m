//
//  ChangeContractLocatlNameViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.01.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "ChangeContractLocatlNameViewController.h"
#import "TextFieldParameterView.h"
#import "Masonry.h"

@interface ChangeContractLocatlNameViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *chnageButton;
@property (weak, nonatomic) UITextField *textField;

@end

static NSInteger textFieldTopOffset = 64 + 20;
static NSInteger textFieldHeight = 40;
static NSInteger textFieldLeading = 20;
static NSInteger textFieldTrailing = -20;

@implementation ChangeContractLocatlNameViewController

@synthesize delegate, contract;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configLocalization];
    [self makeConstraintForAmountInput];
}

#pragma mark -

- (TextFieldWithLine*)changeNameTextFiled {
    
    TextFieldWithLine *textField = (TextFieldWithLine *)[[[NSBundle mainBundle] loadNibNamed:@"TextFieldWithLineDarkSend" owner:self options:nil] lastObject];
    return textField;
}

#pragma mark - Configuration

-(void)configLocalization {
    
    [self.chnageButton setTitle:NSLocalizedString(@"CHANGE", @"Contracts Change Name Controllers button") forState:UIControlStateNormal];
    self.titleTextLabel.text = NSLocalizedString(@"Change contract name", @"Contracts Change Name Controllers Title");
}

-(void)makeConstraintForAmountInput {
    
    TextFieldWithLine *textField = [self changeNameTextFiled];
    self.textField = textField;
    textField.text = self.contract.localName;
    textField.placeholder = NSLocalizedString(@"Contract name", @"Contract name placeholder");
    textField.delegate = self;
    [self.view addSubview:textField];
    
    [textField makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textField.superview.top).with.offset(textFieldTopOffset);
        make.left.equalTo(textField.superview.left).with.offset(textFieldLeading);
        make.right.equalTo(textField.superview.right).with.offset(textFieldTrailing);
        make.height.equalTo(@(textFieldHeight));
    }];
    
    [self updateControllsWithString:textField.text];
}

#pragma mark - Private

- (void)updateControllsWithString:(NSString*) newName {
    
    if (newName.length > 0) {
        self.chnageButton.enabled = YES;
        self.chnageButton.alpha = 1;
    } else {
        self.chnageButton.enabled = NO;
        self.chnageButton.alpha = 0.7;
    }
}

#pragma mark - Actions

- (IBAction)didPressedBackAction:(id) sender {
    [self.delegate didPressedBack];
}

- (IBAction)actionChangeName:(id)sender {
    [self.delegate didChangeName:self.textField.text withContract:self.contract];
}

- (IBAction)didVoidTapAction:(id) sender {
    [self.view endEditing:YES];
}

#pragma makr - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    [self updateControllsWithString:newString];
    
    return YES;
}


@end
