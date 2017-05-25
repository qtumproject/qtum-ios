//
//  TemplateTokenViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 23.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "TemplateTokenViewController.h"
#import "TokenTemplateCell.h"

@interface TemplateTokenViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TemplateTokenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 46;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate didDeselectTemplateIndexPath:indexPath withName:self.templateNames[indexPath.row]];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self.delegate didDeselectFunctionIndexPath:indexPath withItem:self.formModel.functionItems[indexPath.row]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.templateNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TokenTemplateCell* cell = [tableView dequeueReusableCellWithIdentifier:tokenTemplateCellIdentifire];
    cell.templateName.text = self.templateNames[indexPath.row];
    return cell;
}

- (IBAction)didPressedBackAction:(id)sender {
    [self.delegate createStepOneCancelDidPressed];
}


@end
