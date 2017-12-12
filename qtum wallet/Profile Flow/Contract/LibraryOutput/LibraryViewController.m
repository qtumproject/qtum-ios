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
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;

@end

@implementation LibraryViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];

	self.tableView.dataSource = self.tableSource;
	self.tableView.delegate = self.tableSource;
}

#pragma mark - Configuration

-(void)configLocalization {
    
    self.titleTextLabel.text = NSLocalizedString(@"Library", @"Library Controllers Title");
}

#pragma mark - Actions

- (IBAction)actionBack:(id) sender {
	[self.delegate didBackPressed];
}

@end
