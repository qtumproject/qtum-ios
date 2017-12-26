//
//  TokenFunctionViewControllerLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 01.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "TokenFunctionViewControllerLight.h"
#import "NoContractView.h"

@interface TokenFunctionViewControllerLight ()

@end

@implementation TokenFunctionViewControllerLight

- (NoContractView *)getNoContractView {
    
    NoContractView *noContractView = [[[NSBundle mainBundle] loadNibNamed:@"NoContractViewLight" owner:self options:nil] objectAtIndex:0];
    return noContractView;
}

- (void)tableView:(UITableView *) tableView didHighlightRowAtIndexPath:(NSIndexPath *) indexPath {
}

- (void)tableView:(UITableView *) tableView didUnhighlightRowAtIndexPath:(NSIndexPath *) indexPath {
}

@end
