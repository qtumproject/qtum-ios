//
//  SmartContractsListViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "SmartContractsListViewController.h"
#import "SmartContractListItemCell.h"

@interface SmartContractsListViewController () <UITableViewDelegate, UITableViewDataSource,QTUMSwipableCellWithButtonsDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *emptyTableLabel;
@property (weak, nonatomic) IBOutlet UIView *trainingView;

@property (assign, nonatomic) BOOL needShowTrainingScreen;

@property (nonatomic, strong) NSMutableSet *cellsCurrentlyEditing;
@property (weak, nonatomic) UITableViewCell *movingCell;


@end

@implementation SmartContractsListViewController

@synthesize delegate, contracts, smartContractPretendents;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cellsCurrentlyEditing = [NSMutableSet new];
    [self configTableView];
    [self configTrainingView];
}

#pragma mark - Configuration

-(void)configTableView {
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if (self.smartContractPretendents.count == 0 && self.contracts.count == 0) {
        
        self.emptyTableLabel.hidden = NO;
        self.needShowTrainingScreen = NO;
    } else {
        
        self.emptyTableLabel.hidden = YES;
    }
}

-(void)configTrainingView {
    
    if (!self.needShowTrainingScreen) {
        [self.trainingView removeFromSuperview];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section != 0) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.delegate didSelectContractWithIndexPath:indexPath withContract:self.contracts[indexPath.row]];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.smartContractPretendents.count;
    } else {
        return self.contracts.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return [self configContractPretendentCellWithTableView:tableView ForRowAtIndexPath:indexPath];
    } else {
        
        return [self configContractCellWithTableView:tableView ForRowAtIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 31;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        UITableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"ContractsHeaderView"];
        return  headerCell;
    }
    return nil;
}

#pragma mark - Configuration 

-(SmartContractListItemCell*)configContractCellWithTableView:(UITableView *)tableView ForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Contract* contract = self.contracts[indexPath.row];
    SmartContractListItemCell* cell = [tableView dequeueReusableCellWithIdentifier:smartContractListItemCellIdentifire];
    cell.contractName.text = contract.localName;
    cell.typeIdentifire.text = [contract.templateModel.templateTypeString uppercaseString];
    cell.creationDate.text = contract.creationDateString;
    cell.delegate = self;
    return cell;
}

-(SmartContractListItemCell*)configContractPretendentCellWithTableView:(UITableView *)tableView ForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    NSDictionary* pretendentDict = self.smartContractPretendents.allValues[indexPath.row];
    TemplateModel* template = pretendentDict[kTemplateModel];
    NSString* localName = pretendentDict[kLocalContractName];
    SmartContractListItemCell* cell = [tableView dequeueReusableCellWithIdentifier:smartContractListItemCellIdentifire];
    cell.contractName.text = localName;
    cell.typeIdentifire.text = [template.templateTypeString uppercaseString];
    cell.creationDate.text = NSLocalizedString(@"Unconfirmed", nil);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}

#pragma mark - Actions

- (IBAction)didPressedBackAction:(id)sender {
    [self.delegate didPressedBack];
}

- (IBAction)didScipTrainingInfoAction:(id)sender {
    
    __weak __typeof(self)weakSelf = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.trainingView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf.trainingView removeFromSuperview];
        [weakSelf.delegate didTrainingPass];
    }];
}

#pragma mark - PublishedContractListOutput

-(void)setNeedShowingTrainingScreen {
    
    self.needShowTrainingScreen = YES;
}

#pragma mark - QTUMSwipableCellWithButtonsDelegate

- (void)buttonOneActionForIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        NSString* hexKey = self.smartContractPretendents.allKeys[indexPath.row];
        [self.delegate didUnsubscribeFromContractPretendentWithTxHash:hexKey];
    } else if(indexPath.row == 1) {
        
        Contract* contract = self.contracts[indexPath.row];
        [self.delegate didUnsubscribeFromContract:contract];
    }
}

- (void)buttonTwoActionForIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)cellDidOpen:(UITableViewCell *)cell {
    
    for (QTUMSwipableCellWithButtons* openedCell in self.cellsCurrentlyEditing) {
        if (![cell isEqual:openedCell]) {
            [openedCell closeCell];
        }
    }
    [self.cellsCurrentlyEditing addObject:cell];
}

- (void)cellDidClose:(UITableViewCell *)cell {
    
    [self.cellsCurrentlyEditing removeObject:cell];
}

- (void)cellDidStartMoving:(UITableViewCell *)cell {
    
    if (self.movingCell) {
        [(QTUMSwipableCellWithButtons*)self.movingCell closeCell];
    }
    self.movingCell = cell;
    self.tableView.scrollEnabled = NO;
}

- (void)cellEndMoving:(UITableViewCell *)cell {
    
    if (![cell isEqual:self.movingCell]) {
        [(QTUMSwipableCellWithButtons*)cell closeCell];
    } else {
        self.movingCell = nil;
        self.tableView.scrollEnabled = YES;
    }
}

- (BOOL)shoudOpenCell:(UITableViewCell *)cell {
    
    if (self.movingCell && [cell isEqual:self.movingCell]) {
        return YES;
    } else if (self.movingCell){
        return NO;
    }else {
        return YES;
    }
}


@end
