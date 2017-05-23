//
//  LanguageViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 23.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "LanguageViewController.h"
#import "LanguageCoordinator.h"

@interface LanguageViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self.tableSource;
    self.tableView.delegate = self.tableSource;
}

#pragma mark - Actions

- (IBAction)actionBack:(id)sender {
    [self.delegate didBackButtonPressed];
}

@end
