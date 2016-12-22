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
@property (weak, nonatomic) IBOutlet UILabel *brainKeyLabel;

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
        resultSting = [NSString stringWithFormat:@"%@/n%@",resultSting,item];
    }
    return resultSting;
}

#pragma mark - Configuration 

-(void)configurationBrainKeyLabel{
    self.brainKeyLabel.text = [self stringForLabelWithArrayWords:nil];
}

#pragma mark - Actions

- (IBAction)showMenu:(id)sender {
    [[ApplicationCoordinator sharedInstance] showMenu];
}


@end
