//
//  PublicKeyViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 23.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "PublicKeyViewController.h"
#import "QRCodeManager.h"

@interface PublicKeyViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *publicKeyImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)backButtonWasPressed:(id)sender;
@end

@implementation PublicKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.publicKeyString) {
        [self createQRCode];
        [self copyAddressAndShowMessage];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Methods

- (void)copyAddressAndShowMessage
{
    UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:self.publicKeyString];
    
    [self showAlertWithTitle:nil mesage:@"Address copied" andActions:nil];
}

- (void)createQRCode
{
    __weak typeof(self) weakSelf = self;
    [QRCodeManager createQRCodeFromString:self.publicKeyString forSize:self.publicKeyImageView.frame.size withСompletionBlock:^(CIImage *image, NSString *message) {
        weakSelf.publicKeyImageView.image = [UIImage imageWithCIImage:image];
        [weakSelf.activityIndicator stopAnimating];
    }];
}

#pragma mark - Actions

- (IBAction)backButtonWasPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
