//
//  SettingsViewController.m
//  qtum wallet
//
//  Created by Никита Федоренко on 16.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "SettingsViewController.h"
#import "ApplicationCoordinator.h"

@interface SettingsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Actions

- (IBAction)actionLogout:(id)sender {
    [[WalletManager sharedInstance] clear];
    [[ApplicationCoordinator sharedInstance] startWalletFlow];
}
- (IBAction)actionMenu:(id)sender {
//    [[ApplicationCoordinator sharedInstance] showMenu];
}


#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell;
    
    switch (indexPath.row) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"changePin"];
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"walletBackup"];
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [[ApplicationCoordinator sharedInstance] startChangePinFlow];
            break;
        case 1:
            [[ApplicationCoordinator sharedInstance] showExportBrainKeyAnimated:YES];

            break;
            
        default:
            break;
    }
}

@end
