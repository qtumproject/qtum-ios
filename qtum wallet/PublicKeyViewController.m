//
//  PublicKeyViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 23.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "PublicKeyViewController.h"

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
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *stringData = [weakSelf.publicKeyString dataUsingEncoding: NSUTF8StringEncoding];
        
        CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        [qrFilter setValue:stringData forKey:@"inputMessage"];
        [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
        
        CIImage *qrImage = qrFilter.outputImage;
        float scaleX = weakSelf.publicKeyImageView.frame.size.width / qrImage.extent.size.width;
        float scaleY = weakSelf.publicKeyImageView.frame.size.height / qrImage.extent.size.height;
        
        qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            weakSelf.publicKeyImageView.image = [UIImage imageWithCIImage:qrImage];
            [weakSelf.activityIndicator stopAnimating];
        });
    });
}

#pragma mark - Actions

- (IBAction)backButtonWasPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
