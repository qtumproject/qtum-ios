//
//  QStoreViewControllerLight.m
//  qtum wallet
//
//  Created by Никита Федоренко on 17.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreViewControllerLight.h"

@interface QStoreViewControllerLight ()

@end

@implementation QStoreViewControllerLight

- (void)createSelectSearchView {
    
    self.selectSearchType = [[[NSBundle mainBundle] loadNibNamed:@"SelectSearchTypeViewLight" owner:self options:nil] firstObject];
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

- (void)createContainer {
    self.containerForSearchElements = [UIView new];
    self.containerForSearchElements.translatesAutoresizingMaskIntoConstraints = NO;
    self.containerForSearchElements.backgroundColor = [UIColor whiteColor];
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
    [self.searchTableView registerNib:[UINib nibWithNibName:@"QStoreSearchTableViewCellLight" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"QStoreSearchTableViewCell"];
    self.searchTableView.separatorColor = lightBlueColor();
    self.searchTableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
    self.searchTableView.backgroundColor = [UIColor whiteColor];
    
    [self.containerForSearchElements addSubview:self.searchTableView];
    
    NSDictionary *views = @{@"searchTableView" : self.searchTableView, @"selectSearchType" : self.selectSearchType};
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[selectSearchType]-0-[searchTableView]-0-|" options:0 metrics:nil views:views];
    NSArray *horisontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[searchTableView]-0-|" options:0 metrics:nil views:views];
    
    [self.containerForSearchElements addConstraints:horisontalConstraints];
    [self.containerForSearchElements addConstraints:verticalConstraints];
}

@end
