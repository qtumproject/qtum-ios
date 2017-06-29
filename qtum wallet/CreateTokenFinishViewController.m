//
//  CreateTokenFinishViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "CreateTokenFinishViewController.h"
#import "ContractCoordinator.h"
#import "FinishInputCell.h"
#import "ResultTokenInputsModel.h"

@interface CreateTokenFinishViewController () <PopUpWithTwoButtonsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CreateTokenFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 85, 0);
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.inputs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FinishInputCell* cell = [tableView dequeueReusableCellWithIdentifier:FinishInputCellIdentifire];
    cell.name.text = self.inputs[indexPath.row].name;
    cell.value.text = [NSString stringWithFormat:@"%@",self.inputs[indexPath.row].value];

    return cell;
}

#pragma mark - Actions 

- (IBAction)didBackPressedAction:(id)sender {
    [self.delegate finishStepBackDidPressed];
}

- (IBAction)didFinishPressedAction:(id)sender {
    [self.delegate finishStepFinishDidPressed];
}

#pragma mark - methods

- (void)showCompletedPopUp{
    [[PopUpsManager sharedInstance] showInformationPopUp:self withContent:[PopUpContentGenerator getContentForCreateContract] presenter:nil completion:nil];
}

- (void)showErrorPopUp{
    [[PopUpsManager sharedInstance] showErrorPopUp:self withContent:[PopUpContentGenerator getContentForOupsPopUp] presenter:nil completion:nil];
}

#pragma mark - PopUpWithTwoButtonsViewControllerDelegate

- (void)okButtonPressed:(PopUpViewController *)sender{
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
    [self.delegate didPressedQuit];
}

- (void)cancelButtonPressed:(PopUpViewController *)sender{
    [[PopUpsManager sharedInstance] hideCurrentPopUp:YES completion:nil];
}

@end
