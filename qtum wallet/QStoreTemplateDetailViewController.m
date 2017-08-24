//
//  QStoreTemplateDetailViewController.m
//  qtum wallet
//
//  Created by Никита Федоренко on 24.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreTemplateDetailViewController.h"
#import "InterfaceInputFormModel.h"
#import "QStoreTemplateFunctionCell.h"
#import "AbiinterfaceItem.h"

@interface QStoreTemplateDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation QStoreTemplateDetailViewController

@synthesize delegate, formModel;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self reloadTable];
}

#pragma mark - Private Methods

-(void)reloadTable{
    __weak __typeof(self)weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.tableView reloadData];
    });
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 46;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.formModel.propertyItems.count;
    } else {
        return self.formModel.functionItems.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        QStoreTemplateFunctionCell* cell = [tableView dequeueReusableCellWithIdentifier:qstoreTemplateFunctionCellPropertyIdentifire];
        cell.methodName.text = self.formModel.propertyItems[indexPath.row].name;
        return cell;
    } else {
        QStoreTemplateFunctionCell* cell = [tableView dequeueReusableCellWithIdentifier:qstoreTemplateFunctionCellFunctionIdentifire];
        cell.methodName.text = self.formModel.functionItems[indexPath.row].name;
        return cell;
    }
}

- (IBAction)didPressedBackAction:(id)sender {
    
    [self.delegate didPressedBack];
}


@end
