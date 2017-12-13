//
//  LanguageViewController.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 23.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "LanguageViewController.h"
#import "LanguageTableSource.h"

@interface LanguageViewController () <LanguageTableSourceDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;

@property (nonatomic) LanguageTableSource *source;

@end

@implementation LanguageViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    
	[super viewDidLoad];

	self.tableView.dataSource = self.source;
	self.tableView.delegate = self.source;
    
    [self configLocalization];
}

#pragma mark - Configuration

-(void)configLocalization {
    
    self.titleTextLabel.text = NSLocalizedString(@"Language", @"Language Controllers Title");
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

- (IBAction)actionBack:(id) sender {
	[self.delegate didBackPressed];
}

@end
