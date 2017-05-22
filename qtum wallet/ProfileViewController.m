//
//  ProfileViewController.m
//  qtum wallet
//
//  Created by Никита Федоренко on 28.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileTableViewCell.h"
#import "SubscribeTokenCoordinator.h"
#import "CreateTokenCoordinator.h"

@interface ProfileViewController ()

@property (weak, nonatomic) UIView* footerView;
@property (strong,nonatomic) SubscribeTokenCoordinator* subscribeCoordinator;
@property (strong,nonatomic) CreateTokenCoordinator* createTokenCoordinator;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //TODO Make normal coordinator callback
    self.subscribeCoordinator = nil;
    self.createTokenCoordinator = nil;
}

#pragma mark - Setters/Getters

-(UIView*)footerView{
    UIView* footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 13)];
    footer.backgroundColor = [UIColor colorWithRed:36/255. green:41/255. blue:49/255. alpha:1];
    return footer;
}

-(UIView*)highlightedView{
    UIView * selectedBackgroundView = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor:customRedColor()];
    return selectedBackgroundView;
}

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
            return 2;
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
        cell = [tableView dequeueReusableCellWithIdentifier:@"profileCellWithSeparator"];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell"];
    }
    [self configurateCell:cell atIndexPath:indexPath];
    return cell;
}

-(void)configurateCell:(ProfileTableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath{
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
            text = NSLocalizedString(@"Change Pin", "");
        } else if (indexPath.row == 1) {
            image = [UIImage imageNamed:@"backup_wallet_icon"];
            text = NSLocalizedString(@"Wallet Back Up", "");
        } else if (indexPath.row == 2) {
            image = [UIImage imageNamed:@"import_wallet_icon"];
            text = NSLocalizedString(@"Import", "");
        }
    } else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            image = [UIImage imageNamed:@"ic-token"];
            text = NSLocalizedString(@"Create Token", "");
        } else if (indexPath.row == 1) {
            
            image = [UIImage imageNamed:@"ic-token-subscribe"];
            text = NSLocalizedString(@"Subscribe Token", "");
        }
    } else{
        if (indexPath.row == 0) {
            image = [UIImage imageNamed:@"info_icon"];
            text = NSLocalizedString(@"About", "");
        } else if (indexPath.row == 1) {
            
            image = [UIImage imageNamed:@"ic-logout"];
            text = NSLocalizedString(@"Logout", "");
        }
    }
    
    cell.profileCellImage.image = image;
    cell.profileCellTextLabel.text = text;
    cell.diclousereImageView.tintColor = customBlueColor();

    [cell setSelectedBackgroundView:[self highlightedView]];
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self actionLanguage:nil];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self actionChangePin:nil];
        } else if (indexPath.row == 1) {
            [self actionWalletBackup:nil];
        } else if (indexPath.row == 2) {
            [self actionImport:nil];
        }
    } else if(indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self actionCreateToken:nil];
        } else if (indexPath.row == 1) {
            [self actionSubscribeToken:nil];
        }
    }else {
        if (indexPath.row == 0) {
            [self actionAbout:nil];
        } else if (indexPath.row == 1) {
            [[ApplicationCoordinator sharedInstance] logout];
        }
    }
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ProfileTableViewCell* cell = (ProfileTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.profileCellImage.tintColor = customBlackColor();
    cell.profileCellTextLabel.textColor = customBlackColor();
    cell.diclousereImageView.tintColor = customBlackColor();
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ProfileTableViewCell* cell = (ProfileTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.profileCellImage.tintColor = customBlueColor();
    cell.profileCellTextLabel.textColor = customBlueColor();
    cell.diclousereImageView.tintColor = customBlueColor();
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    switch (section) {
        case 0:
            return self.footerView;
            break;
        case 1:
            return self.footerView;
            break;
        case 2:
            return self.footerView;
            break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 13;
            break;
        case 1:
            return 13;
            break;
        case 2:
            return 13;
            break;
            
        default:
            return 0;
            break;
    }
}

#pragma mark - Actions 

-(IBAction)actionLanguage:(id)sender{
    
}

-(IBAction)actionChangePin:(id)sender{
    [self performSegueWithIdentifier:@"changePin" sender:nil];
}

-(IBAction)actionWalletBackup:(id)sender{
    [self performSegueWithIdentifier:@"exportBrainKey" sender:nil];
}

-(IBAction)actionImport:(id)sender{
    [self performSegueWithIdentifier:@"importBrainKey" sender:nil];
}

-(IBAction)actionAbout:(id)sender{
    
}

-(IBAction)actionCreateToken:(id)sender{
    self.createTokenCoordinator = [[CreateTokenCoordinator alloc] initWithNavigationController:self.navigationController];
    [self.createTokenCoordinator start];
}

-(IBAction)actionSubscribeToken:(id)sender{
    self.subscribeCoordinator = [[SubscribeTokenCoordinator alloc] initWithNavigationController:self.navigationController];
    [self.subscribeCoordinator start];
}

#pragma mark - Unwing seque

-(IBAction)unwingToProfile:(UIStoryboardSegue *)segue {
}



@end
