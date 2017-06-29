//
//  ExportBrainKeyViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 22.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "ExportBrainKeyViewController.h"
#import "WalletManager.h"

@interface ExportBrainKeyViewController () <PopUpViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *brainKeyView;
@property (weak, nonatomic) IBOutlet NSString *brainKey;

@end

@implementation ExportBrainKeyViewController

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
    [self.brainKeyView sizeToFit];
}

#pragma mark - Actions


- (IBAction)actionCopy:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.brainKey;
    
    [[PopUpsManager sharedInstance] showInformationPopUp:self withContent:[PopUpContentGenerator getContentForBrainCodeCopied] presenter:nil completion:nil];
}

- (IBAction)actionContinue:(id)sender {
    [[ApplicationCoordinator sharedInstance] startMainFlow];
}

- (IBAction)shareButtonWasPressed:(id)sender
{
    NSString *brainKey = self.brainKey;
    
    NSArray *sharedItems = @[brainKey];
    UIActivityViewController *sharingVC = [[UIActivityViewController alloc] initWithActivityItems:sharedItems applicationActivities:nil];
    [self presentViewController:sharingVC animated:YES completion:nil];
}

#pragma mark - PopUpViewControllerDelegate

- (void)okButtonPressed:(PopUpViewController *)sender {
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
}

@end
