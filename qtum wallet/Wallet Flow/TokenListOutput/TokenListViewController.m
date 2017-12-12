//
//  TokenListViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "TokenListViewController.h"
#import "TokenCell.h"
#import "QRCodeManager.h"

@interface TokenListViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TokenListViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self.tableView reloadData];
    [self configLocalization];
}

#pragma mark - Configuration

-(void)configLocalization {
    
    self.titleTextLabel.text = NSLocalizedString(@"Other Tokens", @"Other Tokens Controllers Title");
}

#pragma mark - Coordinator invocation

- (void)reloadTable {
	__weak __typeof (self) wealSelf = self;
	dispatch_async (dispatch_get_main_queue (), ^{
		[wealSelf.tableView reloadData];
	});
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {

	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	[self.delegate didSelectTokenIndexPath:indexPath withItem:self.tokens[indexPath.row]];
}

- (CGFloat)tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
	return 0;
}

- (void)tableView:(UITableView *) tableView didHighlightRowAtIndexPath:(NSIndexPath *) indexPath {

	TokenCell *cell = (TokenCell *)[tableView cellForRowAtIndexPath:indexPath];
	[cell changeHighlight:YES];
}

- (void)tableView:(UITableView *) tableView didUnhighlightRowAtIndexPath:(NSIndexPath *) indexPath {

	TokenCell *cell = (TokenCell *)[tableView cellForRowAtIndexPath:indexPath];
	[cell changeHighlight:NO];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
	return self.tokens.count;
}

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
	return nil;
}

#pragma mark - Actions

- (IBAction)actionShare:(id) sender {
	[self createAndShareQRCode];
}

#pragma mark - Share Tokens

- (void)createAndShareQRCode {

	if (self.tokens.count == 0) {
		[SVProgressHUD showErrorWithStatus:NSLocalizedString(@"You haven't tokens for share", nil)];
		return;
	}

	[SLocator.popupService showLoaderPopUp];

	NSMutableArray *array = [NSMutableArray new];
	for (Contract *token in self.tokens) {

		[array addObject:token.contractAddress];
	}

	__weak typeof (self) weakSelf = self;
	[QRCodeManager createQRCodeFromContractsTokensArray:[array copy] forSize:CGSizeMake (500, 500) withCompletionBlock:^(UIImage *image) {
		[SLocator.popupService dismissLoader];
		if (!image) {
			[SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error in QRCodeCreation", nil)];
		} else {
			[weakSelf shareQRCode:image];
		}
	}];
}

- (void)shareQRCode:(UIImage *) image {
	NSString *text = NSLocalizedString(@"It's my tokens", nil);
	UIImage *qrCode = image;

	NSArray *sharedItems = @[qrCode, text];
	UIActivityViewController *sharingVC = [[UIActivityViewController alloc] initWithActivityItems:sharedItems applicationActivities:nil];

	[self presentViewController:sharingVC animated:YES completion:nil];
}

@end
