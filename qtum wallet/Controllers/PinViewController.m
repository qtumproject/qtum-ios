//
//  PinViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "PinViewController.h"
#import "CustomTextField.h"

const float bottomOffsetKeyboard = 300;
const float bottomOffset = 25;


@interface PinViewController () <UITextFieldDelegate, CAAnimationDelegate>

@property (weak, nonatomic) IBOutlet UILabel *controllerTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmButtonTopOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonTopOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmButtonBottomOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonBottomOffset;


@end

@implementation PinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.firstSymbolTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Keyboard

-(void)keyboardWillShow:(NSNotification *)sender{
    NSTimeInterval duration = [[sender userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    [self.cancelButtonBottomOffset setActive:NO];
    [self.cancelButtonTopOffset setActive:YES];

    [self.confirmButtonBottomOffset setActive:NO];
    [self.confirmButtonTopOffset setActive:YES];
    
    [self changeConstraintsAnimatedWithTime:duration];
}

-(void)keyboardWillHide:(NSNotification *)sender{
    NSTimeInterval duration = [[sender userInfo][UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    [self.cancelButtonBottomOffset setActive:YES];
    [self.confirmButtonBottomOffset setActive:YES];
    
    [self.cancelButtonTopOffset setActive:NO];
    [self.confirmButtonTopOffset setActive:NO];
    [self changeConstraintsAnimatedWithTime:duration];
}

#pragma mark - Configuration

#pragma mark - Privat Methods

-(void)validateAndSendPin{
    NSString* pin = [NSString stringWithFormat:@"%@%@%@%@",self.firstSymbolTextField.realText,self.secondSymbolTextField.realText,self.thirdSymbolTextField.realText,self.fourthSymbolTextField.realText];
    __weak typeof(self) weakSelf = self;
    if (pin.length == 4) {
        [self.delegatePin confirmPin:pin andCompletision:^(BOOL success) {
            if (success) {
                [weakSelf.view endEditing:YES];
            }else {
                [weakSelf accessPinDenied];
            }
        }];
        [self clearPinTextFields];
        [self.firstSymbolTextField becomeFirstResponder];
    } else {
        [self accessPinDenied];
    }

}

-(void)changeConstraintsAnimatedWithTime:(NSTimeInterval)time{
    [UIView animateWithDuration:time animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Actions

- (IBAction)actionEnterPin:(id)sender {
    [self validateAndSendPin];
}

- (IBAction)actionCancel:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark - 

-(void)setCustomTitle:(NSString*) title{
    self.controllerTitle.text = title;
}

-(void)needBackButton:(BOOL) flag{
    
}


@end
