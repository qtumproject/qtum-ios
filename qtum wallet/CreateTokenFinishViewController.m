//
//  CreateTokenFinishViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "CreateTokenFinishViewController.h"
#import "CreateTokenCoordinator.h"
#import "FinishInputCell.h"
#import "ResultTokenInputsModel.h"

@interface CreateTokenFinishViewController ()

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

@end
