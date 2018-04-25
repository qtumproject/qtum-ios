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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topOffsetConstraint;

@end

static const NSInteger unsuportedMaxDecimal = 128;

@implementation TokenListViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self.tableView reloadData];
    [self configLocalization];
    [self configTopOffset];
}

#pragma mark - Configuration

-(void)configLocalization {
    
    self.titleTextLabel.text = NSLocalizedString(@"Other Tokens", @"Other Tokens Controllers Title");
}

-(void)configTopOffset {
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (screenSize.height == 812.0f) {
        self.topOffsetConstraint.constant = 20;
    }
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

    TokenCell *cell = (TokenCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.type == Unsupported) {
        [self.delegate didSelectUnsupportedTokenTokenIndexPath:indexPath withItem:self.tokens[indexPath.row]];
    } else {
        [self.delegate didSelectTokenIndexPath:indexPath withItem:self.tokens[indexPath.row]];
    }
}

- (CGFloat)tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
	return 0;
}

- (void)tableView:(UITableView *) tableView didHighlightRowAtIndexPath:(NSIndexPath *) indexPath {

	TokenCell *cell = (TokenCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.type != Unsupported) {
        [cell changeHighlight:YES];
    }
}

- (void)tableView:(UITableView *) tableView didUnhighlightRowAtIndexPath:(NSIndexPath *) indexPath {

	TokenCell *cell = (TokenCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.type != Unsupported) {
        [cell changeHighlight:NO];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
	return self.tokens.count;
}

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    
    Contract* token = self.tokens[indexPath.row];
    TokenCell *cell;
    
    if ([token.decimals isGreaterThanOrEqualToInt:unsuportedMaxDecimal]) {
        cell = [tableView dequeueReusableCellWithIdentifier:tokenCellUnsupportedIdentifire];
        cell.tokenName.text = token.localName;
        cell.mainValue.text = NSLocalizedString(@"Unsupported", @"Unsupported token text");
        cell.type = Unsupported;
        cell.token = token;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:tokenCellIdentifire];
        [cell setupWithObject:self.tokens[indexPath.row]];
        [cell changeHighlight:NO];
    }

    return cell;
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
