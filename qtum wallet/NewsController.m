//
//  NewsController.m
//  qtum wallet
//
//  Created by Никита Федоренко on 07.02.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "NewsController.h"
#import "NewsCellModel.h"
#import "NewsTableCell.h"

@interface NewsController ()

@property (strong,nonatomic)UIRefreshControl* refresh;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray <NewsCellModel*> * dataArray;

@end

@implementation NewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configTableView];
    [self configPullRefresh];
    [self getData];
    
    [SVProgressHUD show];
    self.tableView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self endEditing:nil];
}

#pragma mark - Configuration

-(void)configPullRefresh{
    self.refresh = [[UIRefreshControl alloc] init];
    [_refresh addTarget:self action:@selector(actionRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refresh];
}

-(void)configTableView{
   // self.tableView.contentInset = UIEdgeInsetsMake(self.tableView.contentInset.top + 64, 0, 0, 0);
    //self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.tableView.scrollIndicatorInsets.top + 64, 0, 0, 0);
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.estimatedRowHeight = 270;
}

#pragma mark - Private Methods

-(IBAction)endEditing:(id)sender{
    [self.view endEditing:YES];
}

-(void)parceResponse:(id)response{
    if (!response || ![response isKindOfClass:[NSArray class]]) { return; }
    self.dataArray = @[].mutableCopy;
    for (id item in response) {
        NewsCellModel* object = [[NewsCellModel alloc] initWithDict:item];
        [self.dataArray addObject:object];
    }
    [self.refresh endRefreshing];
    [self reloadTable];
}

-(void)getData{
    __weak __typeof(self) weakSelf = self;
    [[RequestManager sharedInstance] getNews:^(id responseObject) {
        [weakSelf parceResponse:responseObject];
    } andFailureHandler:^(NSError *error, NSString *message) {
        [weakSelf requestFailed];
//        [UIAlertController showMessageWithTitle:@"Error" andMessage:@"Cant get data"];
    }];
}


-(void)requestFailed{
    [self.refresh endRefreshing];
    [SVProgressHUD dismiss];
}

-(void)reloadTable{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.tableView.hidden = NO;
        [SVProgressHUD dismiss];
        [weakSelf.tableView reloadData];
        [weakSelf.refresh endRefreshing];
    });
}



#pragma mark - Actions


-(void)actionRefresh{
    [self getData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* reuseIdentifire = @"NewsTableCell";
    NewsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifire];
    NewsCellModel* object = self.dataArray[indexPath.row];
    [cell setContentWithDict:object];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




//#pragma mark - UIScrollViewDelegate
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    [self endEditing:nil];
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)aScrollView willDecelerate:(BOOL)decelerate
//{
//    if (!self.refresh.isHidden) {
//        return;
//    }
//    CGPoint offset = aScrollView.contentOffset;
//    CGRect bounds = aScrollView.bounds;
//    CGSize size = aScrollView.contentSize;
//    UIEdgeInsets inset = aScrollView.contentInset;
//    float y = offset.y + bounds.size.height - inset.bottom;
//    float h = size.height;
//    
//    float reload_distance = 50;
//    if(y > h + reload_distance) {
//        [self getDataWithReplacing:NO andSearchText:self.searchBar.text];
//    }
//}
//
//#pragma mark - Seque
//
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    
//}



@end
