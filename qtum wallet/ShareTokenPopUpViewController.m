//
//  ShareTokenPopUpViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 14.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ShareTokenPopUpViewController.h"

@interface ShareTokenPopUpViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation ShareTokenPopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.addressLabel setText:self.addressString];
    [self.abiTextView setText:self.abiString];
    
    [self.abiTextView setContentOffset:CGPointZero];
    NSLog(@"%@", self.abiTextView);
}

- (IBAction)actionCopyAddress:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(copyAddressButtonPressed:)]) {
        [self.delegate copyAddressButtonPressed:self];
    }
}

- (IBAction)actionCopyAbi:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(copyAbiButtonPressed:)]) {
        [self.delegate copyAbiButtonPressed:self];
    }
}

- (IBAction)actionOk:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(okButtonPressed:)]) {
        [self.delegate okButtonPressed:self];
    }
}

@end
