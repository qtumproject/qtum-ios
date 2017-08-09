//
//  QStoreViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 26.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreViewController.h"
#import "QStoreTableSource.h"
#import "CustomSearchBar.h"
#import "SelectSearchTypeView.h"
#import "QStoreSearchTableSource.h"

@interface QStoreViewController () <UISearchBarDelegate, PopUpWithTwoButtonsViewControllerDelegate, SelectSearchTypeViewDelegate, QStoreTableSourceDelegate, QStoreSearchTableSourceDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet CustomSearchBar *searchBar;

@property (nonatomic) QStoreTableSource *source;
@property (nonatomic) QStoreSearchTableSource *searchSource;

@property (nonatomic) UIView *containerForSearchElements;
@property (nonatomic) NSLayoutConstraint *bottomConstraintForContainer;

@property (nonatomic) SelectSearchTypeView *selectSearchType;
@property (nonatomic) UITableView *searchTableView;

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
    
    [UIView animateWithDuration:duration animations:^{
        self.containerForSearchElements.alpha = 1.0f;
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        self.containerForSearchElements.alpha = 0.0f;
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
    DLog(@"Current index : %ld", (long)index);
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar setText:@""];
    [self.searchBar resignFirstResponder];
}

#pragma mark - PopUpWithTwoButtonsViewControllerDelegate

- (void)okButtonPressed:(PopUpViewController *)sender {
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
}

- (void)cancelButtonPressed:(PopUpViewController *)sender {
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
}

#pragma mark - QStoreTableSourceDelegate

- (void)didSelectCollectionCell {
    [self.delegate didSelectQStoreContract];
}

#pragma mark - QStoreSearchTableSourceDelegate

- (void)didSelectSearchCell {
    [self.delegate didSelectQStoreContract];
}

#pragma mark - Methods

- (void)loadTrendingNow {
    [self.delegate didLoadTrendingNow];
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

@end
