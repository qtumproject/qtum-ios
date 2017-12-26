//
//  TokenFunctionViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 19.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "TokenFunctionViewController.h"
#import "TokenFunctionCell.h"
#import "TokenPropertyCell.h"
#import "WalletManager.h"
#import "NoContractView.h"
#import "Masonry.h"

@interface TokenFunctionViewController () <NoContractViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *contractAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *contractAddressTextLabel;
@property (weak, nonatomic) IBOutlet UIView *navigationBarView;

@end

static NSInteger noContractViewTopOffset = 0;
static NSInteger noContractViewBottomOffset = 0;
static NSInteger noContractViewLeading = 0;
static NSInteger noContractViewTrailing = 0;

@implementation TokenFunctionViewController

@synthesize token, delegate, formModel;

#pragma mark - Lifecycle

- (void)viewDidLoad {

	[super viewDidLoad];
    [self configLocalization];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (reloadTable) name:kWalletDidChange object:nil];
	self.contractAddressLabel.text = self.token.mainAddress;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Configuration

-(void)configLocalization {
    
    self.contractAddressTextLabel.text = NSLocalizedString(@"Contract Address", @"");
    self.titleTextLabel.text = NSLocalizedString(@"Functions", @"Functions Controllers Title");
}

#pragma mark - Private Methods

- (void)reloadTable {
	__weak __typeof (self) weakSelf = self;
	dispatch_async (dispatch_get_main_queue (), ^{
		[weakSelf.tableView reloadData];
		weakSelf.contractAddressLabel.text = weakSelf.token.mainAddress;
	});
}

- (NoContractView *)getNoContractView {
    
    NoContractView *noContractView = [[[NSBundle mainBundle] loadNibNamed:@"NoContractView" owner:self options:nil] objectAtIndex:0];
    return noContractView;
}


#pragma mark - NoContractViewDelegate

-(void)didUnsubscribeToken {
    
    if ([self.delegate respondsToSelector:@selector(didUnsubscribeFromDeletedContract:)]) {
        [self.delegate didUnsubscribeFromDeletedContract:self.token];
    }
}

#pragma mark - ContractFunctionsOutput

-(void)showUnsubscribeContractScreen {
    
    
    NoContractView* noContractView = [self getNoContractView];
    noContractView.delegate = self;
    
    [self.view addSubview:noContractView];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(noContractViewTopOffset, noContractViewLeading, noContractViewBottomOffset, noContractViewTrailing);
    
    [noContractView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBarView.bottom).with.offset(padding.top);
        make.left.equalTo(self.view).with.offset(padding.left);
        make.bottom.equalTo(self.view).with.offset(padding.bottom);
        make.right.equalTo(self.view).with.offset(padding.right);
    }];
}



#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {

	return 46;
}

- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (indexPath.section) {
		[self.delegate didSelectFunctionIndexPath:indexPath withItem:self.formModel.functionItems[indexPath.row] andToken:self.token];
	}
}

- (void)tableView:(UITableView *) tableView didDeselectRowAtIndexPath:(NSIndexPath *) indexPath {
	if (indexPath.section) {
		[self.delegate didDeselectFunctionIndexPath:indexPath withItem:self.formModel.functionItems[indexPath.row]];
	}
}

- (void)tableView:(UITableView *) tableView didHighlightRowAtIndexPath:(NSIndexPath *) indexPath {

	if (indexPath.section == 0) {
		return;
	}

	TokenFunctionCell *cell = (TokenFunctionCell *)[tableView cellForRowAtIndexPath:indexPath];
	cell.disclousere.tintColor =
			cell.functionName.textColor = customBlackColor ();
}

- (void)tableView:(UITableView *) tableView didUnhighlightRowAtIndexPath:(NSIndexPath *) indexPath {

	if (indexPath.section == 0) {
		return;
	}

	TokenFunctionCell *cell = (TokenFunctionCell *)[tableView cellForRowAtIndexPath:indexPath];
	cell.disclousere.tintColor =
			cell.functionName.textColor = customBlueColor ();
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
	if (section == 0) {
		return self.formModel.propertyItems.count;
	} else {
		return self.formModel.functionItems.count;
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView {
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {

	if (indexPath.section == 0) {
		TokenPropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:tokenPropertyCelldentifire];
		[cell setupWithObject:self.formModel.propertyItems[indexPath.row] andToken:self.token];
		return cell;
	} else {
		TokenFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:tokenFunctionCellIdentifire];
		[cell setupWithObject:self.formModel.functionItems[indexPath.row]];
		return cell;
	}
}

- (IBAction)didPressedBackAction:(id) sender {
	[self.navigationController popViewControllerAnimated:YES];
}

@end
