//
//  NewsController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 07.02.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "NewsController.h"
#import "NewsCellModel.h"
#import "NewsCoordinator.h"

@interface NewsController ()

@property (strong, nonatomic)UIRefreshControl* refresh;
@property (strong, nonatomic) NSMutableArray <NewsCellModel*> * dataArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *logoView;

@end

@implementation NewsController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configTableView];
    [self configPullRefresh];
    [self configLogo];

    
    [self getData];
    
    [[PopUpsManager sharedInstance] showLoaderPopUp];
    self.tableView.hidden = YES;
}

-(void)configLogo {
    
    UIImage *originalImage = [UIImage imageNamed:@"new-logo.png"];
    UIImage *tintedImage = [originalImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.logoView.tintColor = [self logoColor];
    self.logoView.image = tintedImage;
}

-(UIColor*)logoColor {
    return lightDarkGrayColor();
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self endEditing:nil];
}


#pragma mark - Getters


#pragma mark - Configuration

-(void)configPullRefresh{
    self.refresh = [[UIRefreshControl alloc] init];
    [self.refresh setTintColor:customBlueColor()];
    [self.refresh addTarget:self action:@selector(actionRefresh) forControlEvents:UIControlEventValueChanged];

    [self.tableView addSubview:self.refresh];
}

-(void)configTableView{
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 120.0f;
    
    self.tableView.delegate = self.tableSource;
    self.tableView.dataSource = self.tableSource;
}

#pragma mark - Private Methods

-(IBAction)endEditing:(id)sender{
    [self.view endEditing:YES];
}

-(void)getData{
    [[PopUpsManager sharedInstance] showLoaderPopUp];
    [self.delegate refreshTableViewData];
}


-(void)reloadTableView{
    [self reloadTable];
}

-(void)failedToGetData{
    [[PopUpsManager sharedInstance] dismissLoader];
}

-(void)requestFailed{
    [self.refresh endRefreshing];
    [[PopUpsManager sharedInstance] dismissLoader];
}

-(void)reloadTable{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.tableView.hidden = NO;
        [[PopUpsManager sharedInstance] dismissLoader];
        [weakSelf.tableView reloadData];
        [weakSelf.refresh endRefreshing];
    });
}


#pragma mark - Actions

-(void)actionRefresh{
    [self getData];
}

- (IBAction)actionGoToLink:(id)sender {
    [self.delegate openNewsLink];
}

@end
