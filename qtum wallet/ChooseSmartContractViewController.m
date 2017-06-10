//
//  ChooseSmartContractViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "ChooseSmartContractViewController.h"
#import "ChoiseSmartContractCell.h"

@interface ChooseSmartContractViewController ()

@property (strong,nonatomic) NSArray<NSString*>* contractTypes;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ChooseSmartContractViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.contractTypes = @[NSLocalizedString(@"My New Contracts", @""),NSLocalizedString(@"My Published Contracts", @""),NSLocalizedString(@"Contacts Store", @"")];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 46;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 0) {
        
        [self.delegate didSelectNewContracts];
    } else if (indexPath.row == 1) {
        
        [self.delegate didSelectPublishedContracts];
    } else if (indexPath.row == 2) {
        
        [self.delegate didSelectContractStore];
    }
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChoiseSmartContractCell* cell = (ChoiseSmartContractCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.image.tintColor =
    cell.disclosure.tintColor =
    cell.smartContractType.textColor = customBlackColor();
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChoiseSmartContractCell* cell = (ChoiseSmartContractCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.image.tintColor =
    cell.disclosure.tintColor =
    cell.smartContractType.textColor = customBlueColor();
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.contractTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChoiseSmartContractCell* cell = [tableView dequeueReusableCellWithIdentifier:choiseSmartContractCellIdentifire];
    cell.smartContractType.text = self.contractTypes[indexPath.row];
    
    if (indexPath.row == 0) {
        
        cell.image.image =  [UIImage imageNamed:@"ic-smartContract"];
    } else if (indexPath.row == 1) {
        
        cell.image.image = [UIImage imageNamed:@"ic-publichedContracts"];
    } else if (indexPath.row == 2) {
        
        cell.image.image = [UIImage imageNamed:@"ic-contractStore"];
    }
    
    return cell;
}

- (IBAction)didPressedBackAction:(id)sender {
    
    [self.delegate didPressedQuit];
}


@end
