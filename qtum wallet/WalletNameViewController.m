//
//  WalletNameViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "WalletNameViewController.h"

@interface WalletNameViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonsBottomConstraint;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation WalletNameViewController

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
    [self configTextField];
    [self.nameTextField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Configuration

-(void)configTextField{
    UIColor *color = [UIColor colorWithRed:46/255. green:154/255. blue:208/255. alpha:1];
    self.nameTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Enter Name", "")
                                    attributes:@{
                                                 NSForegroundColorAttributeName: color,
                                                 NSFontAttributeName : [UIFont fontWithName:@"simplonmono-regular" size:16.0]
                                                 }
     ];
}

#pragma mark - Notification

-(void)keyboardWillShow:(NSNotification *)sender{
    CGRect end = [[sender userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.buttonsBottomConstraint.constant = end.size.height;
    [self.view layoutIfNeeded];
    
}

-(void)keyboardWillHide:(NSNotification *)sender{

}

#pragma mark - Actions

- (IBAction)actionConfirm:(id)sender {
    [self.nameTextField resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(didCreatedWalletName:)]) {
        [self.delegate didCreatedWalletName:self.nameTextField.text];
    }
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.nameTextField resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(cancelCreateWallet)]) {
        [self.delegate cancelCreateWallet];
    }
}


@end
