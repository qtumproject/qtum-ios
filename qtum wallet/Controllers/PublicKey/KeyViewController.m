//
//  PublicKeyViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 23.11.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "KeyViewController.h"
#import "QRCodeManager.h"

@interface KeyViewController ()

@property (nonatomic) NSString *keyString;

@property (weak, nonatomic) IBOutlet UIImageView *publicKeyImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *privateKeyButton;

- (IBAction)backButtonWasPressed:(id)sender;
- (IBAction)pirvateKeyButtonWasPressed:(id)sender;
@end

@implementation KeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.privateKeyButton.hidden = self.isPrivate;
    
    self.titleLabel.text = self.isPrivate ? NSLocalizedString(@"Private key", "") : NSLocalizedString(@"Public Key", "");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.key && !self.publicKeyImageView.image) {
        NSString* keyString = [AppSettings sharedInstance].isMainNet ? self.key.address.string : self.key.addressTestnet.string;
        self.keyString = self.isPrivate ? self.key.WIF : keyString;
        
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
    [pb setString:self.keyString];
    
    [self showAlertWithTitle:nil mesage:NSLocalizedString(@"Address copied", "") andActions:nil];
}

- (void)createQRCode
{
    __weak typeof(self) weakSelf = self;
    [QRCodeManager createQRCodeFromString:self.keyString forSize:self.publicKeyImageView.frame.size withCompletionBlock:^(UIImage *image) {
        weakSelf.publicKeyImageView.image = image;
        [weakSelf.activityIndicator stopAnimating];
    }];
}

#pragma mark - Actions

- (IBAction)backButtonWasPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pirvateKeyButtonWasPressed:(id)sender
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    KeyViewController *vc = (KeyViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"KeyViewController"];
    vc.key = self.key;
    vc.isPrivate = YES;
    [self presentViewController:vc animated:YES completion:nil];
}

@end
