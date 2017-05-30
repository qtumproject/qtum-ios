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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate didDeselectTemplateIndexPath:indexPath withName:self.templateModels[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TokenTemplateCell* cell = (TokenTemplateCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.disclousureImage.tintColor =
    cell.tokenIdentifire.textColor =
    cell.creationDate.textColor =
    cell.templateName.textColor = customBlackColor();
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TokenTemplateCell* cell = (TokenTemplateCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.disclousureImage.tintColor =
    cell.tokenIdentifire.textColor =
    cell.creationDate.textColor =
    cell.templateName.textColor = customBlueColor();
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.templateModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TemplateModel* template = self.templateModels[indexPath.row];
    TokenTemplateCell* cell = [tableView dequeueReusableCellWithIdentifier:tokenTemplateCellIdentifire];
    cell.templateName.text = template.templateName;
    cell.tokenIdentifire.text = template.templateTypeString;
    cell.creationDate.text = template.creationDateString;
    return cell;
}

- (IBAction)didPressedBackAction:(id)sender {
    [self.delegate didPressedBack];
}


@end
