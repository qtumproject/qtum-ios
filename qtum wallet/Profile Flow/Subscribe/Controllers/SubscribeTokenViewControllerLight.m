//
//  SubscribeTokenViewControllerLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 27.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "SubscribeTokenViewControllerLight.h"

@interface SubscribeTokenViewControllerLight ()

@end

@implementation SubscribeTokenViewControllerLight


- (void)configSearchBar {

	UITextField *searchTextField = [self.searchBar valueForKey:@"_searchField"];
	if ([searchTextField respondsToSelector:@selector (setAttributedPlaceholder:)]) {
		UIColor *color = [UIColor colorWithRed:255 / 255. green:255 / 255. blue:255 / 255. alpha:0.5];
		[searchTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:NSLocalizedString(@"Search", @"Search placeholder") attributes:@{NSForegroundColorAttributeName: color}]];
	}

	[self.searchBar setImage:[UIImage imageNamed:@"ic-search-clear-light"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
	[self.searchBar setImage:[UIImage imageNamed:@"ic-search-clear-light"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateSelected];
	[self.searchBar setImage:[UIImage imageNamed:@"ic-search-light"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {

	self.searchBar.text = @"";
	[self.view endEditing:YES];
	self.delegateDataSource.tokensArray = self.tokensArray;
	[self updateTable];
}

@end
