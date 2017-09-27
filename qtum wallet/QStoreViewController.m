//
//  QStoreViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 26.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QStoreViewController.h"
#import "QStoreTableSource.h"
#import "SelectSearchTypeView.h"
#import "QStoreSearchTableSource.h"
#import "QStoreContractElement.h"

CGFloat const KeyboardDuration = 0.25f;

@interface QStoreViewController () <UISearchBarDelegate, PopUpWithTwoButtonsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) BOOL wasSettedTag;
@property (nonatomic) NSString *tagString;

@end

@implementation QStoreViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.source = [QStoreTableSource new];
    self.source.delegate = self;
    self.source.tableView = self.tableView;
    
    self.tableView.delegate = self.source;
    self.tableView.dataSource = self.source;
    [self.tableView setDecelerationRate:0.8f];
    
    self.searchBar.delegate = self;
    
    [self createContainer];
    [self createSelectSearchView];
    [self createSearchTableView];
    
    [self loadTrendingNow];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.wasSettedTag) {
        [self.searchBar becomeFirstResponder];
        self.wasSettedTag = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.searchBar resignFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)createContainer {
    self.containerForSearchElements = [UIView new];
    self.containerForSearchElements.translatesAutoresizingMaskIntoConstraints = NO;
    self.containerForSearchElements.backgroundColor = customBlackColor();
    self.containerForSearchElements.alpha = 0.0f;
    
    [self.view addSubview:self.containerForSearchElements];
    
    NSDictionary *views = @{@"containerForSearchElements" : self.containerForSearchElements, @"search" : self.searchBar};
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[search]-0-[containerForSearchElements]" options:0 metrics:nil views:views];
    NSArray *horisontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[containerForSearchElements]-0-|" options:0 metrics:nil views:views];
    self.bottomConstraintForContainer = [NSLayoutConstraint constraintWithItem:self.containerForSearchElements attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0.0f];
    
    [self.view addConstraint:self.bottomConstraintForContainer];
    [self.view addConstraints:horisontalConstraints];
    [self.view addConstraints:verticalConstraints];
}

- (void)createSelectSearchView {
    
    self.selectSearchType = [[[NSBundle mainBundle] loadNibNamed:@"SelectSearchTypeView" owner:self options:nil] firstObject];
    self.selectSearchType.alpha = 1.0f;
    self.selectSearchType.translatesAutoresizingMaskIntoConstraints = NO;
    self.selectSearchType.delegate = self;
    
    [self.containerForSearchElements addSubview:self.selectSearchType];
    
    NSDictionary *views = @{@"selectSearchType" : self.selectSearchType};
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[selectSearchType(28)]" options:0 metrics:nil views:views];
    NSArray *horisontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[selectSearchType]-0-|" options:0 metrics:nil views:views];
    
    [self.containerForSearchElements addConstraints:horisontalConstraints];
    [self.containerForSearchElements addConstraints:verticalConstraints];
}

- (void)createSearchTableView {
    self.searchSource = [QStoreSearchTableSource new];
    self.searchSource.delegate = self;
    
    self.searchTableView = [UITableView new];
    self.searchTableView.tableFooterView = [UIView new];
    self.searchTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.searchTableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.searchTableView.dataSource = self.searchSource;
    self.searchTableView.delegate = self.searchSource;
    [self.searchTableView reloadData];
    [self.searchTableView registerNib:[UINib nibWithNibName:@"QStoreSearchTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"QStoreSearchTableViewCell"];
    self.searchTableView.separatorColor = customBlueColor();
    self.searchTableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    self.searchTableView.backgroundColor = customBlackColor();
    
    [self.containerForSearchElements addSubview:self.searchTableView];
    
    NSDictionary *views = @{@"searchTableView" : self.searchTableView, @"selectSearchType" : self.selectSearchType};
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[selectSearchType]-0-[searchTableView]-0-|" options:0 metrics:nil views:views];
    NSArray *horisontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[searchTableView]-0-|" options:0 metrics:nil views:views];
    
    [self.containerForSearchElements addConstraints:horisontalConstraints];
    [self.containerForSearchElements addConstraints:verticalConstraints];
}

#pragma mark - Notifications

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    CGFloat tapBarHeight = 0.0f;
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tapBarVC = (UITabBarController *)vc;
        tapBarHeight = tapBarVC.tabBar.frame.size.height;
    }
    
    self.bottomConstraintForContainer.constant = - (kbSize.height - tapBarHeight);
    
    [UIView animateWithDuration:duration - 0.05f animations:^{
        self.containerForSearchElements.alpha = 1.0f;
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    self.bottomConstraintForContainer.constant = 0;
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Actions

- (IBAction)actionBack:(id)sender {
    [self.delegate didPressedBack];
}

- (IBAction)actionAdd:(id)sender {
    
}

- (IBAction)actionCategories:(id)sender {
    [self.delegate didSelectQStoreCategories];
}

#pragma mark - SelectSearchTypeViewDelegate

- (void)selectIndexChanged:(NSInteger)index {
    [self.delegate didChangedSearchText:self.searchBar.text orSelectedSearchIndex:index];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.delegate didChangedSearchText:searchText orSelectedSearchIndex:[self.selectSearchType selectedIndex]];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.delegate didChangedSearchText:self.searchBar.text orSelectedSearchIndex:[self.selectSearchType selectedIndex]];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    if (!self.searchBar.cancelButtonShowed) {
        [self.searchBar setShowsCancelButton:YES animated:YES];
    }
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
//    [self.searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar setText:@""];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
    
    [UIView animateWithDuration:KeyboardDuration animations:^{
        self.containerForSearchElements.alpha = 0.0f;
    }];
    
    [self.delegate didChangedSearchText:self.searchBar.text orSelectedSearchIndex:[self.selectSearchType selectedIndex]];
}

#pragma mark - PopUpWithTwoButtonsViewControllerDelegate

- (void)okButtonPressed:(PopUpViewController *)sender {
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
}

- (void)cancelButtonPressed:(PopUpViewController *)sender {
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
}

#pragma mark - QStoreTableSourceDelegate

- (void)didSelectCollectionCellWithElement:(QStoreContractElement *)element {
    [self.delegate didSelectQStoreContractElement:element];
}

#pragma mark - QStoreSearchTableSourceDelegate

- (void)didSelectSearchCellWithElement:(QStoreContractElement *)element {
    QStoreContractElement *el = [[QStoreContractElement alloc] initWithIdString:element.idString
                                                                                     name:element.name
                                                                              priceString:element.priceString
                                                                                 countBuy:element.countBuy
                                                                           countDownloads:element.countDownloads
                                                                                createdAt:element.createdAt
                                                                               typeString:element.typeString];
    [self.delegate didSelectQStoreContractElement:el];
}

- (void)loadMoreElements {
    [self.delegate didLoadMoreElementsForText:self.searchBar.text orSelectedSearchIndex:[self.selectSearchType selectedIndex]];
}

#pragma mark - Methods

- (void)loadTrendingNow {
    [self.delegate didLoadCategories];
}

- (void)startLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[PopUpsManager sharedInstance] showLoaderPopUp];
    });
}

- (void)stopLoading {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[PopUpsManager sharedInstance] dismissLoader];
    });
}

- (void)setCategories:(NSArray<QStoreCategory *> *)categories {
    [self.source setCategoriesArray:categories];
}

- (void)setTag:(NSString *)tag {
    [self.searchBar setText:tag];
    [self.searchBar setShowsCancelButton:YES animated:NO];
    [self.selectSearchType setSelectedIndex:1];
    
    [self.delegate didChangedSearchText:self.searchBar.text orSelectedSearchIndex:[self.selectSearchType selectedIndex]];
    
    self.wasSettedTag = YES;
}

- (void)setSearchElements:(NSArray<QStoreContractElement *> *)elements {
    [self.searchSource setSearchElements:elements];
    [self.searchTableView reloadData];
    [self.searchTableView setContentOffset:CGPointZero animated:NO];
}

- (void)setSearchMoreElements:(NSArray<QStoreContractElement *> *)elements {
    [self.searchSource setSearchElements:elements];
    [self.searchTableView reloadData];
}

@end
