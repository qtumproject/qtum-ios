//
//  PinViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "PinViewController.h"
#import "CustomTextField.h"
#import "Presentable.h"

const float bottomOffsetKeyboard = 300;
const float bottomOffset = 25;

@interface PinViewController () <UITextFieldDelegate, CAAnimationDelegate, Presentable>

@property (weak, nonatomic) IBOutlet UILabel *controllerTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonBottomOffset;

@end

@implementation PinViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.firstSymbolTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Keyboard

-(void)keyboardWillShow:(NSNotification *)sender {
    
    CGRect end = [[sender userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    CGFloat tapBarHeight = 0.0f;
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tapBarVC = (UITabBarController *)vc;
        tapBarHeight = tapBarVC.tabBar.frame.size.height;
    }
    
    self.bottomForButtonsConstraint.constant = end.size.height - tapBarHeight;
    [self.view layoutIfNeeded];
}

-(void)keyboardWillHide:(NSNotification *)sender{
    CGRect end = [[sender userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.bottomForButtonsConstraint.constant = end.size.height;
    [self.view layoutIfNeeded];
}

#pragma mark - Configuration

#pragma mark - Privat Methods

-(void)validateAndSendPin {
    
    NSString* pin = [NSString stringWithFormat:@"%@%@%@%@",self.firstSymbolTextField.realText,self.secondSymbolTextField.realText,self.thirdSymbolTextField.realText,self.fourthSymbolTextField.realText];
    __weak typeof(self) weakSelf = self;
    if (pin.length == 4) {
        [self.delegate confirmPin:pin andCompletision:^(BOOL success) {
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

-(void)changeConstraintsAnimatedWithTime:(NSTimeInterval)time {
    
    [UIView animateWithDuration:time animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Actions

- (IBAction)actionEnterPin:(id)sender {
    [self validateAndSendPin];
}

- (IBAction)actionCancel:(id)sender {
    
    [self.delegate didPressedCancel];
}

#pragma mark - 

-(void)setCustomTitle:(NSString*) title{
    self.controllerTitle.text = title;
}

-(void)needBackButton:(BOOL) flag{
    
}

- (IBAction)actionBack:(id)sender {
    
    [self.delegate didPressedBack];
}

@end
