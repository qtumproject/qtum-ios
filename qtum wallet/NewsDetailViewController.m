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

@interface NewsDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NewsDetailViewController

@synthesize delegate, newsItem, cellBuilder;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configTableView];
    [self.tableView reloadData];
}

#pragma mark - Configuration

-(void)configTableView {
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 120.0f;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsItem.tags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QTUMHTMLTagItem* tag = self.newsItem.tags[indexPath.row];
    return [self.cellBuilder getCellWithTagItem:tag fromTable:tableView withIndexPath:indexPath];
}

#pragma mark - Actions

- (IBAction)doBackAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didBackPressed)]) {
        [self.delegate didBackPressed];
    }
}


#pragma mark - NewsDetailOutputDelegate

-(void)reloadTableView {
    
}

-(void)failedToGetData {
    
}

@end
