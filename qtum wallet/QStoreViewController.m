//
//  QStoreViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 26.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreViewController.h"
#import "QStoreTableSource.h"
#import "UIImage+Extension.h"
#import "ContractFileManager.h"

@interface QStoreViewController () <UISearchBarDelegate, PopUpWithTwoButtonsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic) QStoreTableSource *source;

@end

@implementation QStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.source = [QStoreTableSource new];
    self.tableView.delegate = self.source;
    self.tableView.dataSource = self.source;
    [self.tableView setDecelerationRate:0.8f];
//    UIScrollViewDecelerationRateFast
    [self configSearchBar];
}

-(void)configSearchBar{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(8,0, self.view.frame.size.width - 16, 28)];
    view.backgroundColor = customBlackColor();
    UIImage *img = [UIImage changeViewToImage:view];
    [self.searchBar setSearchFieldBackgroundImage:img forState:UIControlStateNormal];
    [self.searchBar setImage:[UIImage imageNamed: @"Icon-search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    self.searchBar.delegate = self;
}

- (IBAction)actionBack:(id)sender {
    [self.delegate didPressedBack];
}

- (IBAction)actionAdd:(id)sender {
    NSLog(@"Add");
}

- (IBAction)actionCategories:(id)sender {
    PopUpContent *content = [PopUpContentGenerator getContentForSourceCode];
    NSString *code = [[ContractFileManager sharedInstance] getContractWithTemplate:@"Standart"];
    content.messageString = code;
    
    [[PopUpsManager sharedInstance] showSourceCodePopUp:self withContent:content presenter:self completion:nil];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

#pragma mark - PopUpWithTwoButtonsViewControllerDelegate

- (void)okButtonPressed:(PopUpViewController *)sender {
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
}

- (void)cancelButtonPressed:(PopUpViewController *)sender {
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
}

@end
