//
//  LibraryViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 14.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "LibraryViewController.h"

@interface LibraryViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self.tableSource;
    self.tableView.delegate = self.tableSource;
}

- (IBAction)actionBack:(id)sender {
    [self.delegate didBackPressed];
}

@end
