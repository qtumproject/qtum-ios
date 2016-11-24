//
//  AddressListViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddressTableViewCell.h"
#import "KeyViewController.h"
#import "KeysManager.h"
#import "ImportKeyViewController.h"

@interface AddressListViewController () <UITableViewDataSource, UITableViewDelegate, ImportKeyViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)backButtonPressed:(id)sender;
- (IBAction)createNewButtonWasPressed:(id)sender;
@end

@implementation AddressListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
//    [[KeysManager sharedInstance] removeAllKeys];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Actions

- (IBAction)createNewButtonWasPressed:(id)sender
{
    [SVProgressHUD show];
    
    __weak typeof(self) weakSelf = self;
    [[KeysManager sharedInstance] createNewKey];
    [KeysManager sharedInstance].keyRegistered = ^(BOOL registered){
        if (registered) {
            [SVProgressHUD showSuccessWithStatus:@"Done"];
            [weakSelf.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:@"Some Error"];
        }
        [KeysManager sharedInstance].keyRegistered = nil;
    };
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [KeysManager sharedInstance].keys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTableViewCell"];
    if (!cell) {
        cell = [[AddressTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"AddressTableViewCell"];
    }
    
    BTCKey *key = [KeysManager sharedInstance].keys[indexPath.row];
    
    cell.puplicKeyLabel.text = key.address.string;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BTCKey *key = [KeysManager sharedInstance].keys[indexPath.row];
    
    [self createAndPresentPublicKeyVCWithKey:key];
}

#pragma mark - ImportKeyViewControllerDelegate

- (void)addressImported
{
    [self.tableView reloadData];
}

#pragma mark - Methods

- (void)createAndPresentPublicKeyVCWithKey:(BTCKey *)key
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    KeyViewController *vc = (KeyViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"KeyViewController"];
    vc.key = key;
    
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueID = segue.identifier;
    
    if ([segueID isEqualToString:@"AddressListToImport"]) {
        ImportKeyViewController *vc = (ImportKeyViewController *)segue.destinationViewController;
        vc.delegate = self;
    }
}

@end
