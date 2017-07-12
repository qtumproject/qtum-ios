//
//  LanguageViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 23.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "LanguageViewController.h"
#import "LanguageTableSource.h"

@interface LanguageViewController () <LanguageTableSourceDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) LanguageTableSource *source;

@end

@implementation LanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.dataSource = self.source;
    self.tableView.delegate = self.source;
}

- (LanguageTableSource *)source {
    
    if (!_source) {
        _source = [LanguageTableSource new];
        _source.delegate = self;
        _source.cellIdentifier = [self getCellIdentifier];
    }
    return _source;
}

- (NSString *)getCellIdentifier {
    return @"LanguageTableViewCell";
}

#pragma mark - LanguageTableSourceDelegate

- (void)languageDidChanged {
    [self.delegate didLanguageChanged];
}

#pragma mark - Actions

- (IBAction)actionBack:(id)sender {
    [self.delegate didBackPressed];
}

@end
