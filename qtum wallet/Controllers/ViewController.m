//
//  ViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 29.10.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "ViewController.h"
#import "KeysManager.h"
#import "InformationViewController.h"
@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)createNew:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)createNew:(id)sender
{
    [[KeysManager sharedInstance] createNewKey];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [KeysManager sharedInstance].keys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    BTCKey *key = [KeysManager sharedInstance].keys[indexPath.row];
    cell.textLabel.text = key.privateKeyAddress.string;
    cell.detailTextLabel.text = key.address.string;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    InformationViewController *vc = [[InformationViewController alloc] initWithNibName:@"InformationViewController" bundle:nil];
    vc.selectedKey = [KeysManager sharedInstance].keys[indexPath.row];
    if (indexPath.row < [KeysManager sharedInstance].keys.count - 1) {
        vc.nextKey = [KeysManager sharedInstance].keys[indexPath.row + 1];
    }
    [self presentViewController:vc animated:YES completion:nil];
}

@end
