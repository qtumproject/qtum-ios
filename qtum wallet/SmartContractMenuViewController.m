//
//  SmartContractMenuViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "SmartContractMenuViewController.h"
#import "ChoiseSmartContractCell.h"
#import "Presentable.h"

@interface SmartContractMenuViewController () <Presentable>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SmartContractMenuViewController

@synthesize delegate;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.contractTypes = @[NSLocalizedString(@"My Contract Templates", @""),
                           NSLocalizedString(@"My Published Contracts", @""),
//                           NSLocalizedString(@"Contracts Store", @""),
                           NSLocalizedString(@"Watch Contract", @""),
                           NSLocalizedString(@"Watch Token", @""),
                           NSLocalizedString(@"Backup Contracts", @""),
                           NSLocalizedString(@"Restore Contracts", @"")];

    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.row) {
        case 0:
            [self.delegate didSelectNewContracts];
            break;
        case 1:
            [self.delegate didSelectPublishedContracts];
            break;
        case 10:
            [self.delegate didSelectContractStore];
            break;
        case 2:
            [self.delegate didSelectWatchContracts];
            break;
        case 3:
            [self.delegate didSelectWatchTokens];
            break;
        case 4:
            [self.delegate didSelectBackupContract];
            break;
        case 5:
            [self.delegate didSelectRestoreContract];
            break;
        default:
            DLog(@"Incorrect index");
            break;
    }
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{ }
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath { }

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.contractTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChoiseSmartContractCell* cell = [tableView dequeueReusableCellWithIdentifier:choiseSmartContractCellIdentifire];
    cell.smartContractType.text = self.contractTypes[indexPath.row];
    
    UIImage *imageForCell;
    switch (indexPath.row) {
        case 0:
            imageForCell =  [UIImage imageNamed:@"ic-smartContract"];
            break;
        case 1:
            imageForCell = [UIImage imageNamed:@"ic-publichedContracts"];
            break;
        case 10:
            imageForCell = [UIImage imageNamed:@"ic-contractStore"];
            break;
        case 2:
            imageForCell = [UIImage imageNamed:@"ic-contract_watch"];
            break;
        case 3:
            imageForCell =  [UIImage imageNamed:@"ic_token_watch"];
            break;
        case 4:
            imageForCell = [UIImage imageNamed:@"ic_contr_backup"];
            break;
        case 5:
            imageForCell = [UIImage imageNamed:@"ic-contract_restore"];
            break;
        default:
            DLog(@"Incorrect index");
            break;
    }
    
    cell.image.image = imageForCell;
    
    return cell;
}

- (IBAction)didPressedBackAction:(id)sender {
    
    [self.delegate didPressedQuit];
}


@end
