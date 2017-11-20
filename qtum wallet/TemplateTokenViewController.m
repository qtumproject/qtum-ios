//
//  TemplateTokenViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 23.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "TemplateTokenViewController.h"
#import "TokenTemplateCell.h"

@interface TemplateTokenViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TemplateTokenViewController

@synthesize delegate, templateModels;

- (void)viewDidLoad {

	[super viewDidLoad];
	[self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {

	return 46;
}

- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self.delegate didSelectTemplateIndexPath:indexPath withName:self.templateModels[indexPath.row]];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {

	return self.templateModels.count;
}

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {

	TemplateModel *template = self.templateModels[indexPath.row];
	TokenTemplateCell *cell = [tableView dequeueReusableCellWithIdentifier:tokenTemplateCellIdentifire];
	cell.templateName.text = template.templateName;
	cell.tokenIdentifire.text = [template.templateTypeString uppercaseString];
	cell.creationDate.text = template.creationDateString;
	return cell;
}

- (CGFloat)tableView:(UITableView *) tableView heightForHeaderInSection:(NSInteger) section {
	return 31;
}

- (UIView *)tableView:(UITableView *) tableView viewForHeaderInSection:(NSInteger) section {
	UITableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:@"TemplatesHeaderView"];
	return headerCell;
}

- (IBAction)didPressedBackAction:(id) sender {
	[self.delegate didPressedBack];
}


@end
