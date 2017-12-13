//
//  SmartContractsListViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "SmartContractsListViewController.h"
#import "SmartContractListItemCell.h"

@interface SmartContractsListViewController () <UITableViewDelegate, UITableViewDataSource, QTUMSwipableCellWithButtonsDelegate, UIGestureRecognizerDelegate, RemoveContractTrainigViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *emptyTableLabel;

@property (assign, nonatomic) BOOL needShowTrainingScreen;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;

@property (nonatomic, strong) NSMutableSet *cellsCurrentlyEditing;
@property (weak, nonatomic) UITableViewCell *movingCell;

@end

@implementation SmartContractsListViewController

@synthesize delegate, contracts, smartContractPretendents, failedContractPretendents;

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	self.cellsCurrentlyEditing = [NSMutableSet new];
	[self configTableView];
    [self configLocalization];
}

- (void)viewWillAppear:(BOOL) animated {

	[super viewWillAppear:animated];
	[self configAndSetTrainingView];
}

#pragma mark - Custom Accessors


- (RemoveContractTrainigView *)trainingViewWithStyle {

	RemoveContractTrainigView *trainingView = [[[NSBundle mainBundle] loadNibNamed:@"RemoveContractTrainingViewDark" owner:self options:nil] objectAtIndex:0];

	return trainingView;
}

#pragma mark - Configuration

-(void)configLocalization {
    
    self.emptyTableLabel.text = NSLocalizedString(@"No Tokens Found", @"");
    self.titleTextLabel.text = NSLocalizedString(@"Contracts", @"Contracts Controllers Title");
}

- (void)configTableView {

	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	[self updateControls];
}

- (void)configAndSetTrainingView {

	if (self.needShowTrainingScreen) {

		self.trainingView = [self trainingViewWithStyle];
		self.trainingView.delegate = self;
		UIView *window = [UIApplication sharedApplication].keyWindow;
		self.trainingView.frame = window.bounds;
		[window addSubview:self.trainingView];
		[self.trainingView setNeedsLayout];

		__weak __typeof (self) weakSelf = self;
		self.trainingView.alpha = 0;
		[UIView animateWithDuration:0.3 animations:^{
			weakSelf.trainingView.alpha = 1;
		}];
	}
}

- (void)updateControls {

	if (self.smartContractPretendents.count == 0 && self.contracts.count == 0) {

		self.emptyTableLabel.hidden = NO;
		self.needShowTrainingScreen = NO;
		self.tableView.hidden = YES;
	} else {

		self.emptyTableLabel.hidden = YES;
		self.tableView.hidden = NO;
	}
}

- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {

	if (indexPath.section != 0 && indexPath.section != 1) {

		[tableView deselectRowAtIndexPath:indexPath animated:YES];
		[self.delegate didSelectContractWithIndexPath:indexPath withContract:self.contracts[indexPath.row]];
	}
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {

	if (section == 0) {
        
        return self.failedContractPretendents.count;
	} else if (section == 1) {
        
        return self.smartContractPretendents.count;
    } else {
        
        return self.contracts.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView {
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {

	if (indexPath.section == 0) {

		return [self configFailedContractPretendentCellWithTableView:tableView ForRowAtIndexPath:indexPath];
	} else if (indexPath.section == 1){

        return [self configContractPretendentCellWithTableView:tableView ForRowAtIndexPath:indexPath];
    } else {
        
        return [self configContractCellWithTableView:tableView ForRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *) tableView heightForHeaderInSection:(NSInteger) section {

	if (section == 0) {
		return 31;
	}
	return 0;
}

- (CGFloat)tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
	return 45;
}

- (UIView *)tableView:(UITableView *) tableView viewForHeaderInSection:(NSInteger) section {

	if (section == 0) {
		UITableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"ContractsHeaderView"];
		return headerCell;
	}
	return nil;
}

#pragma mark - Configuration

- (SmartContractListItemCell *)configContractCellWithTableView:(UITableView *) tableView ForRowAtIndexPath:(NSIndexPath *) indexPath {

	Contract *contract = self.contracts[indexPath.row];
	SmartContractListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:smartContractListItemCellIdentifire];
	cell.contractName.text = contract.localName;
	cell.typeIdentifire.text = [contract.templateModel.templateTypeString uppercaseString];
	cell.creationDate.text = contract.creationDateString;
	cell.delegate = self;
	cell.indexPath = indexPath;
	return cell;
}

- (SmartContractListItemCell *)configContractPretendentCellWithTableView:(UITableView *) tableView ForRowAtIndexPath:(NSIndexPath *) indexPath {

	NSDictionary *pretendentDict = self.smartContractPretendents.allValues[indexPath.row];
	TemplateModel *template = pretendentDict[kTemplateModel];
	NSString *localName = pretendentDict[kLocalContractName];
	SmartContractListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:smartContractListItemCellIdentifire];
	cell.contractName.text = localName;
	cell.typeIdentifire.text = [template.templateTypeString uppercaseString];
	cell.creationDate.text = NSLocalizedString(@"Unconfirmed", nil);
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.delegate = self;
	cell.indexPath = indexPath;
	return cell;
}

- (SmartContractListItemCell *)configFailedContractPretendentCellWithTableView:(UITableView *) tableView ForRowAtIndexPath:(NSIndexPath *) indexPath {
    
    NSDictionary *pretendentDict = self.failedContractPretendents.allValues[indexPath.row];
    TemplateModel *template = pretendentDict[kTemplateModel];
    NSString *localName = pretendentDict[kLocalContractName];
    SmartContractListItemCell *cell = [tableView dequeueReusableCellWithIdentifier:smartContractListItemCellIdentifire];
    cell.contractName.text = localName;
    cell.typeIdentifire.text = [template.templateTypeString uppercaseString];
    cell.creationDate.text = NSLocalizedString(@"Failed", nil);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.indexPath = indexPath;
    return cell;
}

#pragma mark - Actions

- (IBAction)didPressedBackAction:(id) sender {
	[self.delegate didPressedBack];
}

#pragma mark - RemoveContractTrainigViewDelegate

- (void)didTapOnView {

	__weak __typeof (self) weakSelf = self;

	[UIView animateWithDuration:0.3 animations:^{
		weakSelf.trainingView.alpha = 0;
	}                completion:^(BOOL finished) {
		[weakSelf.trainingView removeFromSuperview];
		[weakSelf.delegate didTrainingPass];
	}];
}

#pragma mark - PublishedContractListOutput

- (void)setNeedShowingTrainingScreen {

	self.needShowTrainingScreen = YES;
}

#pragma mark - QTUMSwipableCellWithButtonsDelegate

- (void)buttonOneActionForIndexPath:(NSIndexPath *) indexPath {

	if (indexPath.section == 0) {

        NSString *hexKey = self.failedContractPretendents.allKeys[indexPath.row];
        NSMutableDictionary *faildedPretendents = [self.failedContractPretendents mutableCopy];
        [faildedPretendents removeObjectForKey:hexKey];
        self.failedContractPretendents = [faildedPretendents copy];
        [self.delegate didUnsubscribeFromFailedContractPretendentWithTxHash:hexKey];


	} else if (indexPath.section == 1) {
        
        NSString *hexKey = self.smartContractPretendents.allKeys[indexPath.row];
        NSMutableDictionary *smartContractsPretendents = [self.smartContractPretendents mutableCopy];
        [smartContractsPretendents removeObjectForKey:hexKey];
        self.smartContractPretendents = [smartContractsPretendents copy];
        [self.delegate didUnsubscribeFromContractPretendentWithTxHash:hexKey];
        
    } else if (indexPath.section == 2){
        
        Contract *contract = self.contracts[indexPath.row];
        [self.delegate didUnsubscribeFromContract:contract];
        NSMutableArray *contracts = [self.contracts mutableCopy];
        [contracts removeObject:contract];
        self.contracts = contracts;
    }

	[self.tableView beginUpdates];
	[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	[self.tableView endUpdates];

	__weak __typeof (self) weakSelf = self;
	dispatch_async (dispatch_get_main_queue (), ^{
		[weakSelf updateControls];
	});
}

- (void)cellDidOpen:(UITableViewCell *) cell {

	for (QTUMSwipableCellWithButtons *openedCell in self.cellsCurrentlyEditing) {
		if (![cell isEqual:openedCell]) {
			[openedCell closeCell];
		}
	}
	[self.cellsCurrentlyEditing addObject:cell];
}

- (void)cellDidClose:(UITableViewCell *) cell {

	[self.cellsCurrentlyEditing removeObject:cell];
}

- (void)cellDidStartMoving:(UITableViewCell *) cell {

	if (self.movingCell) {
		[(QTUMSwipableCellWithButtons *)self.movingCell closeCell];
	}
	self.movingCell = cell;
	self.tableView.scrollEnabled = NO;
}

- (void)cellEndMoving:(UITableViewCell *) cell {

	if (![cell isEqual:self.movingCell]) {
		[(QTUMSwipableCellWithButtons *)cell closeCell];
	} else {
		self.movingCell = nil;
		self.tableView.scrollEnabled = YES;
	}
}

- (BOOL)shoudOpenCell:(UITableViewCell *) cell {

	if (self.movingCell && [cell isEqual:self.movingCell]) {
		return YES;
	} else if (self.movingCell) {
		return NO;
	} else {
		return YES;
	}
}

@end
