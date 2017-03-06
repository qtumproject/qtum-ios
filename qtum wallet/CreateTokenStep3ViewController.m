//
//  CreateTokenStep3ViewController.m
//  qtum wallet
//
//  Created by Никита Федоренко on 03.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "CreateTokenStep3ViewController.h"
#import "CreateTokenCoordinator.h"
#import "TextFieldWithLine.h"

@interface CreateTokenStep3ViewController ()

@property (weak, nonatomic) IBOutlet TextFieldWithLine *initialSupplyTextField;
@property (weak, nonatomic) IBOutlet TextFieldWithLine *decimalUnitsTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonsBottomOffset;

@end

static NSInteger baseButtonsButtomOffset = 30;

@implementation CreateTokenStep3ViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [self.initialSupplyTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Notificztions Handlers

-(void)keyboardWillShow:(NSNotification *)sender{
    CGRect end = [[sender userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.buttonsBottomOffset.constant = end.size.height + baseButtonsButtomOffset;
    [self.view layoutIfNeeded];
}

-(void)keyboardWillHide:(NSNotification *)sender{
    self.buttonsBottomOffset.constant = baseButtonsButtomOffset;
    [self.view layoutIfNeeded];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isEqual:self.initialSupplyTextField]) {
        [self.decimalUnitsTextField becomeFirstResponder];
    } else if ([textField isEqual:self.decimalUnitsTextField]){
        [self actionFinish:nil];
    }
    return YES;
}


#pragma mark - Actions

- (IBAction)actionBack:(id)sender {
    [self.delegate createStepThreeBackDidPressed];
}

- (IBAction)actionFinish:(id)sender {
    [self.delegate createStepThreeNextDidPressedWithSupply:self.initialSupplyTextField.text andUnits:self.decimalUnitsTextField.text];
}

@end
