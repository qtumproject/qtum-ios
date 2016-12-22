//
//  ExportBrainKeyViewController.m
//  qtum wallet
//
//  Created by Никита Федоренко on 22.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "ExportBrainKeyViewController.h"
#import "ApplicationCoordinator.h"
#import "WalletManager.h"

@interface ExportBrainKeyViewController ()
@property (weak, nonatomic) IBOutlet UITextView *brainKeyView;

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
        resultSting = resultSting ? [NSString stringWithFormat:@"%@\n%@",resultSting,item] : [NSString stringWithFormat:@"%@",item];
    }
    return resultSting;
}

#pragma mark - Configuration 

-(void)configurationBrainKeyLabel{
    self.brainKeyView.text = [self stringForLabelWithArrayWords:[[WalletManager sharedInstance] getCurrentWallet].seedWords];
}

#pragma mark - Actions

- (IBAction)showMenu:(id)sender {
    [[ApplicationCoordinator sharedInstance] showMenu];
}


@end
