//
//  SmartContractsListViewControllerDark.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 28.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "SmartContractsListViewControllerDark.h"
#import "SmartContractListItemCell.h"

@interface SmartContractsListViewControllerDark ()

@end

@implementation SmartContractsListViewControllerDark

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SmartContractListItemCell* cell = (SmartContractListItemCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.typeIdentifire.backgroundColor =
    cell.creationDate.textColor =
    cell.contractName.textColor = customBlackColor();
    
    cell.typeIdentifire.textColor = customRedColor();
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SmartContractListItemCell* cell = (SmartContractListItemCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.typeIdentifire.backgroundColor =
    cell.creationDate.textColor =
    cell.contractName.textColor = customBlueColor();
    
    cell.typeIdentifire.textColor = customBlackColor();
}

@end
