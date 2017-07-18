//
//  LibraryTableSource.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 17.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "LibraryTableSource.h"
#import "LibraryTableViewCell.h"

@implementation LibraryTableSource

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 46;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TemplateModel* template = self.templetes[indexPath.row];
    
    if ([template isEqual:self.activeTemplate]) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        self.activeTemplate = nil;
        [self.delegate didResetToDefaults:self];
    } else {
        [self.delegate didSelectTemplate:template sender:self];
    }
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LibraryTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:YES];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LibraryTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:[self.activeTemplate isEqual:self.templetes[indexPath.row]]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.templetes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LibraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:libraryCellIdentifire];
    
    cell.nameLabel.text = self.templetes[indexPath.row].templateName;
    
    if ([self.activeTemplate isEqual:self.templetes[indexPath.row]]) {
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    return cell;
}


@end
