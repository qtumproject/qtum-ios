//
//  QStoreListViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 28.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QStoreListViewController.h"
#import "CustomSearchBar.h"
#import "ErrorPopUpViewController.h"

@class QStoreCategory;
@class QStoreContractElement;

@interface QStoreListViewController () <UISearchBarDelegate, QStoreListTableSourceDelegate, PopUpWithTwoButtonsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet CustomSearchBar *searchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraintForTable;

@property (nonatomic) NSArray<QStoreCategory *> *categories;
@property (nonatomic) NSArray<QStoreContractElement *> *elements;

@end

@implementation QStoreListViewController
@synthesize categoryType = _categoryType;

@synthesize delegate, categoryTitle, type;

- (void)viewDidLoad {
	[super viewDidLoad];

	self.source.delegate = self;
	self.table.dataSource = self.source;
	self.table.delegate = self.source;
	self.table.tableFooterView = [UIView new];

	self.searchBar.delegate = self;
	if (self.type == QStoreContracts) {
		self.titleLabel.text = self.categoryTitle;
	}

	[self createSelectSearchView];
}

- (void)viewWillAppear:(BOOL) animated {
	[super viewWillAppear:animated];

	if ([self.searchBar.text isEqualToString:@""]) {
		[self.delegate didLoadFullData:self];
	}

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector (keyboardWillShow:)
												 name:UIKeyboardWillShowNotification
											   object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector (keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
}

- (void)viewWillDisappear:(BOOL) animated {
	[super viewWillDisappear:animated];

	[self.searchBar resignFirstResponder];
}

- (void)viewDidDisappear:(BOOL) animated {
	[super viewDidDisappear:animated];

	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)createSelectSearchView {
	self.selectSearchType = [[[NSBundle mainBundle] loadNibNamed:@"SelectSearchTypeView" owner:self options:nil] firstObject];
	self.selectSearchType.alpha = 1.0f;
	self.selectSearchType.translatesAutoresizingMaskIntoConstraints = NO;
	self.selectSearchType.delegate = self;

	self.searhTypeContainer.clipsToBounds = YES;
	[self.searhTypeContainer addSubview:self.selectSearchType];

	NSDictionary *views = @{@"selectSearchType": self.selectSearchType};
	NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[selectSearchType]-0-|" options:0 metrics:nil views:views];
	NSArray *horisontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[selectSearchType]-0-|" options:0 metrics:nil views:views];

	[self.searhTypeContainer addConstraints:horisontalConstraints];
	[self.searhTypeContainer addConstraints:verticalConstraints];
}

#pragma mark Protected Methods

- (QStoreListTableSource *)source {
	if (!_source) {
		_source = [QStoreListTableSource new];
	}
	return _source;
}

#pragma mark - Notifications

- (void)keyboardWillShow:(NSNotification *) notification {
	NSDictionary *info = [notification userInfo];
	CGSize kbSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
	CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];

	UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
	CGFloat tapBarHeight = 0.0f;
	if ([vc isKindOfClass:[UITabBarController class]]) {
		UITabBarController *tapBarVC = (UITabBarController *)vc;
		tapBarHeight = tapBarVC.tabBar.frame.size.height;
	}

	self.bottomConstraintForTable.constant = kbSize.height - tapBarHeight;
	if (self.type == QStoreContracts) {
		self.heightForSearhTypeContainer.constant = 28.0f;
	}

	[UIView animateWithDuration:duration animations:^{
		[self.view layoutIfNeeded];
	}];
}

- (void)keyboardWillHide:(NSNotification *) notification {
	NSDictionary *info = [notification userInfo];
	CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];

	self.bottomConstraintForTable.constant = 0;
	self.heightForSearhTypeContainer.constant = 0.0f;

	[UIView animateWithDuration:duration animations:^{
		[self.view layoutIfNeeded];
	}];
}

#pragma mark - SelectSearchTypeViewDelegate

- (void)selectIndexChanged:(NSInteger) index {
	[self.delegate didChangedSearchText:self.searchBar.text orSelectedSearchIndex:index output:self];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *) searchBar {
	[self.delegate didChangedSearchText:self.searchBar.text orSelectedSearchIndex:[self.selectSearchType selectedIndex] output:self];
}

- (void)searchBar:(UISearchBar *) searchBar textDidChange:(NSString *) searchText {
	[self.delegate didChangedSearchText:searchText orSelectedSearchIndex:[self.selectSearchType selectedIndex] output:self];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *) searchBar {
	[self.searchBar setShowsCancelButton:YES animated:YES];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *) searchBar {
	[self.searchBar setShowsCancelButton:NO animated:YES];
	return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
	[self.searchBar setText:@""];
	[self.searchBar resignFirstResponder];

	[self.delegate didChangedSearchText:@"" orSelectedSearchIndex:[self.selectSearchType selectedIndex] output:self];
}

#pragma mark - QStoreListTableSourceDelegate

- (void)didSelectCell:(NSIndexPath *) indexPath {
	if (self.type == QStoreCategories) {
		[self.delegate didSelectQStoreCategory:[self.categories objectAtIndex:indexPath.row]];
	} else {
		[self.delegate didSelectQStoreContract:[self.elements objectAtIndex:indexPath.row]];
	}
}

- (void)loadMoreElements {
	if ([self.searchBar.text isEqualToString:@""]) {
		[self.delegate didLoadMoreFullData:self];
	} else {
		[self.delegate didLoadMoreElementsForText:self.searchBar.text orSelectedSearchIndex:[self.selectSearchType selectedIndex] output:self];
	}
}

#pragma mark - Actions

- (IBAction)actionBack:(id) sender {
	[self.delegate didPressedBack];
}

- (void)setCategories:(NSArray<QStoreCategory *> *) categories {
	_categories = categories;
	self.source.array = categories;
	[self.table reloadData];
}

- (void)setElements:(NSArray<QStoreContractElement *> *) elements {
	_elements = elements;
	self.source.array = elements;
	[self.table reloadData];
	[self.table setContentOffset:CGPointZero animated:NO];
}

- (void)setMoreElements:(NSArray<QStoreContractElement *> *) elements {
	_elements = elements;
	self.source.array = elements;
	[self.table reloadData];
}

#pragma mark - Output

- (void)startLoading {
	[SLocator.popupService showLoaderPopUp];
}

- (void)endLoading {
	[SLocator.popupService dismissLoader];
}

- (void)showErrorWithMessage:(NSString *) message {
	PopUpContent *content = [PopUpContentGenerator contentForOupsPopUp];
	content.titleString = NSLocalizedString(@"Error", nil);
	content.messageString = message;
	ErrorPopUpViewController *error = [SLocator.popupService showErrorPopUp:self withContent:content presenter:nil completion:nil];
	[error setOnlyCancelButton];
}

- (void)okButtonPressed:(PopUpViewController *) sender {
	[SLocator.popupService hideCurrentPopUp:YES completion:nil];
}

- (void)cancelButtonPressed:(PopUpViewController *) sender {
	[SLocator.popupService hideCurrentPopUp:YES completion:nil];
}

@end
