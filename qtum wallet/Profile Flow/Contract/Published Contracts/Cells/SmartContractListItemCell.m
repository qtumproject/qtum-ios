//
//  SmartContractListItemCell.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "SmartContractListItemCell.h"

@interface SmartContractListItemCell()

@end

@implementation SmartContractListItemCell

- (IBAction)actionRename:(id)sender {
    
    [self.smartContractDelegate renameForIndexPath:self.indexPath];
}

@end
