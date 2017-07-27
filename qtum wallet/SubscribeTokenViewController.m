//
//  SubscribeTokenViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "SubscribeTokenViewController.h"
#import "SubscribeTokenDataDisplayManagerDark.h"
#import "SubscribeTokenCoordinator.h"
#import "UIImage+Extension.h"
#import "TockenCellSubscribe.h"

@interface SubscribeTokenViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SubscribeTokenViewController

@synthesize delegate, tokensArray, delegateDataSource;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configTableView];
    [self configSearchBar];
    [self updateTable];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTable) name:kTokenDidChange object:nil];
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Configuration

-(void)configTableView {
    
    self.tableView.dataSource = self.delegateDataSource;
    self.tableView.delegate = self.delegateDataSource;
    self.delegateDataSource.tokensArray = self.tokensArray;
}

-(void)configSearchBar {
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(8,0, self.view.frame.size.width - 16, 28)];
    view.backgroundColor = customBlackColor();
    UIImage *img = [UIImage changeViewToImage:view];
    [self.searchBar setSearchFieldBackgroundImage:img forState:UIControlStateNormal];
    [self.searchBar setImage:[UIImage imageNamed: @"Icon-search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
}

#pragma mark - Private Methods

-(void)updateTable {
    
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
}

-(NSArray <Contract*>*)filteringContractsName:(NSArray <Contract*>*) contracts containsText:(NSString*) containtsText {
    
    if (containtsText.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"localName CONTAINS[c] %@", containtsText];
        NSArray *filteredArray = [contracts filteredArrayUsingPredicate:predicate];
        return [filteredArray sortedArrayUsingComparator:^NSComparisonResult(Contract *obj1, Contract *obj2) {
            NSInteger i1 = [obj1.localName rangeOfString:containtsText options:NSCaseInsensitiveSearch].location;
            NSInteger i2 = [obj2.localName rangeOfString:containtsText options:NSCaseInsensitiveSearch].location;
            
            return i1 < i2 ? NSOrderedAscending : i1 == i2 ? NSOrderedSame : NSOrderedDescending;
        }];
    } else {
        return contracts;
    }
}

#pragma mark - Accesers 

- (IBAction)actionBack:(id)sender {
    [self.delegate didBackButtonPressed];
}
- (IBAction)didPressesAddNewAction:(id)sender {
//    [self.delegate didAddNewPressed];
}

- (void)tableView:(UITableView *)tableView didSelectContract:(Contract *) contract {
    [self.delegate didSelectContract:contract];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.delegateDataSource.tokensArray = [self filteringContractsName:[self.tokensArray copy] containsText:searchText];
    [self updateTable];
}

@end
