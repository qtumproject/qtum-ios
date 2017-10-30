//
//  NewsDetailViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 20.10.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "QTUMDefaultTagCell.h"
#import "QTUMHTMLTagItem.h"
#import "QTUMNewsItem.h"
#import "NewsDetailCellBuilder.h"
#import "LoaderPopUpViewController.h"

@interface NewsDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) LoaderPopUpViewController* loader;
@property (weak, nonatomic) IBOutlet UIView *loaderPlaceholderView;

@end

@implementation NewsDetailViewController

@synthesize delegate, newsItem, cellBuilder;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configTableView];
    
    if (!self.newsItem.tags) {
        [self getData];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.loader reloadLoaderAnimation];
    [self reloadTableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!CGRectEqualToRect(self.loader.view.frame, self.loaderPlaceholderView.bounds)) {
        self.loader.view.frame = self.loaderPlaceholderView.bounds;
    }
}

#pragma mark - Configuration

-(void)configTableView {
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 250.0f;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsItem.tags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QTUMHTMLTagItem* tag = self.newsItem.tags[indexPath.row];
    return [self.cellBuilder getCellWithTagItem:tag fromTable:tableView withIndexPath:indexPath];
}

-(void)getData {
    
    [self.delegate refreshTagsWithNewsItem:self.newsItem];
}

#pragma mark - Actions

- (IBAction)doBackAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didBackPressed)]) {
        [self.delegate didBackPressed];
    }
}

-(void)startLoading {
    LoaderPopUpViewController* loader = [[PopUpsManager sharedInstance] showLoaderPopUpInView:self.loaderPlaceholderView];
    self.loader = loader;
}

-(void)stopLoadingIfNeeded {
    [[PopUpsManager sharedInstance] dismissLoader:self.loader];
    self.loader = nil;
}



#pragma mark - NewsDetailOutputDelegate

-(void)reloadTableView {
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
}

-(void)failedToGetData {
    
}

@end
