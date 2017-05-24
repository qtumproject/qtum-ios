//
//  ExportWalletBrandKeyViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 22.02.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "ExportWalletBrandKeyViewController.h"

@interface ExportWalletBrandKeyViewController ()

@property (weak, nonatomic) IBOutlet UILabel *brainKeyView;
@property (weak, nonatomic) IBOutlet NSString *brainKey;

@end

@implementation ExportWalletBrandKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurationBrainKeyLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods

-(NSString*)stringForLabelWithArrayWords:(NSArray*) array {
    NSString* resultSting;
    for (id item in array) {
        resultSting = resultSting ? [NSString stringWithFormat:@"%@ %@",resultSting,item] : [NSString stringWithFormat:@"%@",item];
    }
    return resultSting;
}

#pragma mark - Configuration

-(void)configurationBrainKeyLabel{
    self.brainKeyView.text =
    self.brainKey = [self stringForLabelWithArrayWords:[[WalletManager sharedInstance] getCurrentWallet].seedWords];
}

#pragma mark - Actions


- (IBAction)actionCopy:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.brainKey;
    [self showAlertWithTitle:nil mesage:NSLocalizedString(@"Brain-CODE copied", "") andActions:nil];
}

- (IBAction)actionContinue:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didExportWallet)]) {
        [self.delegate didExportWallet];
    }
}

- (IBAction)shareButtonWasPressed:(id)sender
{
    NSString *brainKey = self.brainKey;
    NSArray *sharedItems = @[brainKey];
    UIActivityViewController *sharingVC = [[UIActivityViewController alloc] initWithActivityItems:sharedItems applicationActivities:nil];
    [self presentViewController:sharingVC animated:YES completion:nil];
}

@end
