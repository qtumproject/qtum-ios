//
//  PinViewController.m
//  qtum wallet
//
//  Created by Никита Федоренко on 13.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "PinViewController.h"
#import "CustomTextField.h"

@interface PinViewController () <UITextFieldDelegate, CAAnimationDelegate>

@property (weak, nonatomic) IBOutlet CustomTextField *firstSymbolTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *secondSymbolTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *thirdSymbolTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *fourthSymbolTextField;
@property (weak, nonatomic) IBOutlet UIView *pinContainer;
@property (weak, nonatomic) IBOutlet UIButton *enterButton;

@end

@implementation PinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.firstSymbolTextField becomeFirstResponder];
    [self configEnterButton];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([self.delegate respondsToSelector:@selector(setAnimationState:)]) {
        [self.delegate setAnimationState:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Configuration

-(void)configEnterButton{
    NSString* title;
    switch (self.type) {
        case EnterType:
            title = @"Enter PIN";
            break;
        case CreateType:
            title = @"Create PIN";
            break;
        case ConfirmType:
            title = @"Repeat PIN";
            break;
        case OldType:
            title = @"Old PIN";
            break;
        case NewType:
            title = @"New PIN";
            break;
            
        default:
            title = @"Enter PIN";
            break;
    }
    [self.enterButton setTitle:title forState:UIControlStateNormal];
}
#pragma mark - Privat Methods

-(void)validateAndSendPin{
    NSString* pin = [NSString stringWithFormat:@"%@%@%@%@",self.firstSymbolTextField.text,self.secondSymbolTextField.text,self.thirdSymbolTextField.text,self.fourthSymbolTextField.text];
    __weak typeof(self) weakSelf = self;
    if (pin.length == 4) {
        [self.delegate confirmPin:pin andCompletision:^(BOOL success) {
            if (!success) {
                [weakSelf accessPinDenied];
            }
        }];
    } else {
        [self accessPinDenied];
    }
    [self.view endEditing:YES];

//    [self.firstSymbolTextField becomeFirstResponder];
}

-(void)redirectTextField:(UITextField*)textField isReversed:(BOOL) reversed{
    if (reversed) {
        if ([textField isEqual:self.fourthSymbolTextField]) {
            [self.thirdSymbolTextField becomeFirstResponder];
        } else if ([textField isEqual:self.thirdSymbolTextField]) {
            [self.secondSymbolTextField becomeFirstResponder];
        } else if ([textField isEqual:self.secondSymbolTextField]) {
            [self.firstSymbolTextField becomeFirstResponder];
        } else if ([textField isEqual:self.firstSymbolTextField]) {
            
        }
    } else {
        if ([textField isEqual:self.firstSymbolTextField]) {
            [self.secondSymbolTextField becomeFirstResponder];
        } else if ([textField isEqual:self.secondSymbolTextField]) {
            [self.thirdSymbolTextField becomeFirstResponder];
        } else if ([textField isEqual:self.thirdSymbolTextField]) {
            [self.fourthSymbolTextField becomeFirstResponder];
        } else if ([textField isEqual:self.fourthSymbolTextField]) {
            [self validateAndSendPin];
        }
    }
}

-(void)accessPinDenied {
    CAKeyframeAnimation* shake = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    shake.duration = 0.6;
    shake.values = @[@-20.0, @20.0, @-20.0, @20.0, @-10.0, @10.0, @-5.0, @5.0, @0.0];
    shake.delegate = self;
    [self.pinContainer.layer addAnimation:shake forKey:@"shake"];
    [self clearPinTextFields];
}

-(void)clearPinTextFields{
    self.firstSymbolTextField.text =
    self.secondSymbolTextField.text =
    self.thirdSymbolTextField.text =
    self.fourthSymbolTextField.text = @"";
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (flag && self.type == ConfirmType) {
        if ([self.delegate respondsToSelector:@selector(confilmPinFailed)]) {
            [self.delegate confilmPinFailed];
        }
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason NS_AVAILABLE_IOS(10_0){
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string.length && [string rangeOfString:@" "].location == NSNotFound) {
        textField.text = [string substringToIndex:1];
        [self redirectTextField:textField isReversed:NO];
    }else {
        textField.text = @"";
        [self redirectTextField:textField isReversed:YES];
    }
    return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    NSLog(@"clear");
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - Actions


- (IBAction)actionEnterPin:(id)sender {
    [self validateAndSendPin];
}


@end
