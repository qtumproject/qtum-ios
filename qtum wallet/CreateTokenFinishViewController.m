//
//  CreateTokenFinishViewController.m
//  qtum wallet
//
//  Created by Никита Федоренко on 17.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "CreateTokenFinishViewController.h"
#import "CreateTokenCoordinator.h"
#import "FinishInputCell.h"
#import "ResultTokenCreateInputModel.h"

@interface CreateTokenFinishViewController ()

@end

@implementation CreateTokenFinishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
