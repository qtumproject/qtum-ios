//
//  SmartContractMenuViewControllerLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 28.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "SmartContractMenuViewControllerLight.h"
#import "ChoiseSmartContractCellLight.h"


@interface SmartContractMenuViewControllerLight ()

@end

@implementation SmartContractMenuViewControllerLight

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChoiseSmartContractCell* cell;
    
    switch (indexPath.row) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
            cell = [tableView dequeueReusableCellWithIdentifier:choiseSmartContractLightCellIdentifire];
            break;

        case 6:
            cell = [tableView dequeueReusableCellWithIdentifier:choiseSmartContractLightHightCellIdentifire];
            break;
            
        default:
            cell = [tableView dequeueReusableCellWithIdentifier:choiseSmartContractLightHightCellIdentifire];
        break;
    }
    
    [self configurateCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
            return 40;
            break;
        case 6:
            return 52;
        default:
            return 40;
    }
}

- (void)configurateCell:(ChoiseSmartContractCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    UIImage *imageForCell;
    switch (indexPath.row) {
        case 0:
            imageForCell =  [UIImage imageNamed:@"ic-newContracts-light"];
            break;
        case 1:
            imageForCell = [UIImage imageNamed:@"ic-publichedContracts-light"];
            break;
        case 2:
            imageForCell = [UIImage imageNamed:@"ic-contractStore-light"];
            break;
        case 3:
            imageForCell = [UIImage imageNamed:@"ic-contract_watch-light"];
            break;
        case 4:
            imageForCell =  [UIImage imageNamed:@"ic-contract_watch1-light"];
            break;
        case 5:
            imageForCell = [UIImage imageNamed:@"ic_contr_backup-light"];
            break;
        case 6:
            imageForCell = [UIImage imageNamed:@"ic-contract_restore-light"];
            break;
        default:
            DLog(@"Incorrect index");
            break;
    }
    
    cell.image.image = imageForCell;
    cell.smartContractType.text = self.contractTypes[indexPath.row];
    
    [cell setSelectedBackgroundView:[self getHighlightedView]];
}


- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    

}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {

}

-(UIView *)getHighlightedView {
    
    UIView * selectedBackgroundView = [[UIView alloc] init];
    [selectedBackgroundView setBackgroundColor:lightBlueColor()];
    return selectedBackgroundView;
}

@end
