//
//  SmartContractsListViewControllerDark.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 28.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "SmartContractsListViewControllerDark.h"
#import "SmartContractListItemCellDark.h"

@interface SmartContractsListViewControllerDark ()

@end

@implementation SmartContractsListViewControllerDark

- (void)tableView:(UITableView *) tableView didHighlightRowAtIndexPath:(NSIndexPath *) indexPath {

	SmartContractListItemCellDark *cell = (SmartContractListItemCellDark *)[tableView cellForRowAtIndexPath:indexPath];
	cell.typeIdentifire.backgroundColor =
			cell.creationDate.textColor =
					cell.contractName.textColor = customBlackColor ();
	cell.myContentView.backgroundColor = customRedColor ();
	cell.typeIdentifire.textColor = customRedColor ();
    cell.renameIcon.tintColor = customRedColor ();
    cell.renameIcon.backgroundColor = customBlackColor ();
}

- (void)tableView:(UITableView *) tableView didUnhighlightRowAtIndexPath:(NSIndexPath *) indexPath {

	SmartContractListItemCellDark *cell = (SmartContractListItemCellDark *)[tableView cellForRowAtIndexPath:indexPath];
	cell.typeIdentifire.backgroundColor =
			cell.creationDate.textColor =
					cell.contractName.textColor = customBlueColor ();
	cell.typeIdentifire.textColor = customBlackColor ();
	cell.myContentView.backgroundColor = customBlackColor ();
    cell.renameIcon.tintColor = customBlackColor ();
    cell.renameIcon.backgroundColor = customBlueColor ();
}


- (CGFloat)tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {

	return 53;
}

@end
