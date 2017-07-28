//
//  SmartContractsListViewControllerLight.m
//  qtum wallet
//
//  Created by Никита Федоренко on 28.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "SmartContractsListViewControllerLight.h"
#import "SmartContractListItemCell.h"

@interface SmartContractsListViewControllerLight ()

@end

@implementation SmartContractsListViewControllerLight

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SmartContractListItemCell* cell = (SmartContractListItemCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.typeIdentifire.backgroundColor = lightGreenColor();

}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SmartContractListItemCell* cell = (SmartContractListItemCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.typeIdentifire.backgroundColor = lightGreenColor();
}

@end
