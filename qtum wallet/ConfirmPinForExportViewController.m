//
//  ConfirmPinForExportViewController.m
//  qtum wallet
//
//  Created by Никита Федоренко on 12.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "ConfirmPinForExportViewController.h"
#import "LoginViewOutputDelegate.h"
#import "Presentable.h"

@interface ConfirmPinForExportViewController () <CAAnimationDelegate, Presentable>

@property (assign, nonatomic) BOOL shoudKeboardDismiss;
@property (assign, nonatomic) BOOL editingStarted;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end


@implementation ConfirmPinForExportViewController

@synthesize delegate;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSInteger textfieldsWithButtonHeight = 250;

    self.bottomConstraintForCancelButton.constant = self.view.frame.size.height / 2. - textfieldsWithButtonHeight / 2.;
    
    if (self.editingStarted) {
        [self startEditing];
    }
}

-(void)didMoveToParentViewController:(UIViewController *)parent {
    
    [super didMoveToParentViewController:parent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}
#pragma mark - Keyboard

-(void)keyboardWillShow:(NSNotification *)sender {
    
    CGRect end = [[sender userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.bottomConstraintForCancelButton.constant = end.size.height;
    [self.view layoutIfNeeded];
}

-(void)startEditing {
    
    self.editingStarted = YES;
    [self.firstSymbolTextField becomeFirstResponder];
}

-(void)stopEditing {
    
    self.editingStarted = NO;
    [self.view endEditing:YES];
}

#pragma mark - Configuration

#pragma mark - Privat Methods

#pragma mark - Actions

- (IBAction)actionEnterPin:(id)sender {
    
    self.shoudKeboardDismiss = YES;
    NSString* pin = [NSString stringWithFormat:@"%@%@%@%@",self.firstSymbolTextField.realText,self.secondSymbolTextField.realText,self.thirdSymbolTextField.realText,self.fourthSymbolTextField.realText];
    if (pin.length == 4) {
        if ([self.delegate respondsToSelector:@selector(passwordDidEntered:)]) {
            [self.delegate passwordDidEntered:pin];
        }
    } else {
        [self applyFailedPasswordAction];
    }
}

- (IBAction)actionCancel:(id)sender {
    self.shoudKeboardDismiss = YES;
    if ([self.delegate respondsToSelector:@selector(confirmPasswordDidCanceled)]) {
        [self.delegate confirmPasswordDidCanceled];
    }
}

-(void)actionEnter:(id)sender {
    
    [self actionEnterPin:nil];
}

-(void)showLoginFields {
    
    self.pinContainer.hidden = NO;
    self.cancelButton.hidden = NO;
    [self.firstSymbolTextField becomeFirstResponder];
}

-(void)applyFailedPasswordAction {
    
    [self accessPinDenied];
    [self clearPinTextFields];
    [self.firstSymbolTextField becomeFirstResponder];
}

- (IBAction)didVoidTapAction:(id)sender {
    
    if (!([self.firstSymbolTextField isFirstResponder] ||
        [self.secondSymbolTextField isFirstResponder] ||
        [self.thirdSymbolTextField isFirstResponder] ||
        [self.fourthSymbolTextField isFirstResponder])) {
        
        [self.firstSymbolTextField becomeFirstResponder];
    }
}


@end
