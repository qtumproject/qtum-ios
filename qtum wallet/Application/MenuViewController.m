//
//  MenuViewController.m
//  qtum wallet
//
//  Created by Nikita on 13.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell;
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:91/255. green:167/255. blue:196/255. alpha:0.9];
    switch (indexPath.row) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"walletCell"];
            [cell setSelectedBackgroundView:bgColorView];
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"settingsCell"];
            [cell setSelectedBackgroundView:bgColorView];
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 80;
            break;
        case 1:
            return 42;
            break;
        case 2:
            return 42;
            break;
            
        default:
            break;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
