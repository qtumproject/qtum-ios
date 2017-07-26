//
//  ProfileViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 28.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileTableViewCell.h"
#import "SubscribeTokenCoordinator.h"
#import "ContractCoordinator.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark - Setters/Getters

-(UIView *)getFooterView { return nil; }

-(UIView *)getHighlightedView { return nil; }

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return [AppSettings sharedInstance].isFingerprintAllowed ? 3 : 2;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProfileTableViewCell* cell;
    if (indexPath.row > 0) {
        if (indexPath.section == 1 && indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:switchCellReuseIdentifire];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:separatorCellReuseIdentifire];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:normalCellReuseIdentifire];
    }
    
    [self configurateCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configurateCell:(ProfileTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    UIImage* image;
    NSString* text;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            image = [UIImage imageNamed:@"language_icon"];
            text = NSLocalizedString(@"Language", "");
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            image = [UIImage imageNamed:@"pin_icon"];
            text = NSLocalizedString(@"Change PIN", "");
        } else if (indexPath.row == 1) {
            image = [UIImage imageNamed:@"backup_wallet_icon"];
            text = NSLocalizedString(@"Wallet Backup", "");
        } else if (indexPath.row == 2) {
            image = [UIImage imageNamed:@"ic-touchID"];
            text = NSLocalizedString(@"Touch ID", "");
            cell.switchControl.on = [AppSettings sharedInstance].isFingerprintEnabled;
        }
    } else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            image = [UIImage imageNamed:@"ic-smartContract"];
            text = NSLocalizedString(@"Smart Contracts", "");
        } else if (indexPath.row == 1) {
            
            image = [UIImage imageNamed:@"ic-token-subscribe"];
            text = NSLocalizedString(@"Token Subscriptions", "");
        }
    } else{
        if (indexPath.row == 0) {
            image = [UIImage imageNamed:@"info_icon"];
            text = NSLocalizedString(@"About", "");
        } else if (indexPath.row == 1) {
            
            image = [UIImage imageNamed:@"ic-logout"];
            text = NSLocalizedString(@"Log Out", "");
//            image = [UIImage imageNamed:@"ic-themes"];
//            text = NSLocalizedString(@"Themes", "");
        }else if (indexPath.row == 2) {
            
            image = [UIImage imageNamed:@"ic-logout"];
            text = NSLocalizedString(@"Log Out", "");
        }
    }
    
    cell.profileCellImage.image = image;
    cell.profileCellTextLabel.text = text;

    [cell setSelectedBackgroundView:[self getHighlightedView]];
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self actionLanguage];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self actionChangePin];
        } else if (indexPath.row == 1) {
            [self actionWalletBackup];
        }
    } else if(indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self actionCreateToken];
        } else if (indexPath.row == 1) {
            [self actionSubscribeToken];
        }
    }else {
        if (indexPath.row == 0) {
            [self actionAbout];
        } else if (indexPath.row == 1) {
            [self actionLogout];
//            [self actionThemes];
        } else if (indexPath.row == 2) {
            [self actionLogout];
        }
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    switch (section) {
        case 0:
        case 1:
        case 2:
            return [self getFooterView];
            break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    switch (section) {
        case 0:
        case 1:
        case 2:
            return 13;
            break;
        default:
            return 0;
            break;
    }
}

#pragma mark - Actions 

- (void)didSwitchFingerprintSettingsAction:(UISwitch *)sender {
    [self.delegate didChangeFingerprintSettings:sender.isOn];
}

- (void)actionLanguage {
    [self.delegate didPressedLanguage];
}

- (void)actionChangePin {
    [self.delegate didPressedChangePin];
}

- (void)actionWalletBackup {
    [self.delegate didPressedWalletBackup];
}

- (void)actionAbout {
    [self.delegate didPressedAbout];
}

- (void)actionCreateToken {
    [self.delegate didPressedCreateToken];
}

- (void)actionSubscribeToken {
    [self.delegate didPressedSubscribeToken];
}

- (void)actionLogout {
    [self.delegate didPressedLogout];
}

- (void)actionThemes {
    [self.delegate didPressedThemes];
}



@end
