//
//  QStoreListViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 28.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreListViewController.h"
#import "QStoreListTableSource.h"
#import "CustomSearchBar.h"

@class QStoreCategory;
@class QStoreContractElement;

@interface QStoreListViewController () <UISearchBarDelegate, QStoreListTableSourceDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet CustomSearchBar *searchBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraintForTable;

@property (nonatomic) QStoreListTableSource *source;

@property (nonatomic) NSArray<QStoreCategory *> *categories;
@property (nonatomic) NSArray<QStoreContractElement *> *elements;

@end

@implementation QStoreListViewController

@synthesize delegate, categoryTitle, type;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.source = [QStoreListTableSource new];
    self.source.delegate = self;
    self.table.dataSource = self.source;
    self.table.delegate = self.source;
    self.table.tableFooterView = [UIView new];
    
    self.searchBar.delegate = self;
    
    if (self.type == QStoreContracts) {
        self.titleLabel.text = self.categoryTitle;
        self.source.array = self.elements;
    } else {
        self.source.array = self.categories;
    }
    
    [self.table reloadData];
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
    
    self.bottomConstraintForTable.constant = kbSize.height - tapBarHeight;
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    self.bottomConstraintForTable.constant = 0;
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
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

#pragma mark - QStoreListTableSourceDelegate

- (void)didSelectCell:(NSIndexPath *)indexPath {
    if (self.type == QStoreCategories) {
        [self.delegate didSelectQStoreCategory:[self.categories objectAtIndex:indexPath.row]];
    } else {
        [self.delegate didSelectQStoreContract:[self.elements objectAtIndex:indexPath.row]];
    }
}

#pragma mark - Actions

- (IBAction)actionBack:(id)sender {
    [self.delegate didPressedBack];
}

- (void)setCategories:(NSArray<QStoreCategory *> *)categories {
    _categories = categories;
}

- (void)setElements:(NSArray<QStoreContractElement *> *)elements {
    _elements = elements;
}

@end
