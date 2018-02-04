//
//  WalletHistoryDelegateDataSource.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 06.03.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "WalletTableSource.h"
#import "HistoryTableViewCell.h"
#import "LoadingFooterCell.h"

@interface WalletTableSource () <NSFetchedResultsControllerDelegate>

@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, weak) HistoryHeaderVIew *sectionHeaderView;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic) BOOL isScrollingAnimation;
@property (nonatomic) BOOL shouldShowLoadingCell;
@property (nonatomic) BOOL isLoadingNow;

@end

static NSInteger batchSize = 25;

@implementation WalletTableSource

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WalletHistoryEntity" inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"address" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    fetchRequest.fetchLimit = batchSize;
    fetchRequest.fetchBatchSize = batchSize;
    fetchRequest.fetchOffset = 0;

    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[NSManagedObjectContext MR_defaultContext] sectionNameKeyPath:nil cacheName:nil];
    self.fetchedResultsController = theFetchedResultsController;
    self.fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}

- (void)setupFething {
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    [self fethcFromStart];
}

-(void)fethcFromStart {
    
    self.currentPage = 0;
    [self.delegate refreshTableViewDataFromStart];
    self.isLoadingNow = YES;
}

- (void)refreshDatas:(NSNotification*)notification {
    
    if ([notification object] == SLocator.coreDataService.managedObjectContext) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.fetchedResultsController.fetchRequest setFetchLimit:6];
            [self.fetchedResultsController performFetch:nil];
            [self.tableView reloadData];
        });
    }
}

- (void)reloadWithFeching {

    self.currentPage += 1;
    NSInteger itemsToShow = self.currentPage * batchSize;
    [self.fetchedResultsController.fetchRequest setFetchLimit:itemsToShow];
    self.shouldShowLoadingCell = itemsToShow < SLocator.historyFacadeService.totalItems;
    [self.fetchedResultsController performFetch:nil];
    self.isLoadingNow = NO;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
	return nil;
}

- (void)configureCell:(UITableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {

}

- (CGFloat)tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
	return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView {
    
    return self.fetchedResultsController.sections.count + 1;
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {

	if (section == 0) {
		return 1;
	} else {
        NSInteger numberOfStorageObjects = [[[self fetchedResultsController] sections][section - 1] numberOfObjects];
        self.emptyPlacehodlerView.hidden = numberOfStorageObjects > 0 ? YES : NO;
        return self.shouldShowLoadingCell && numberOfStorageObjects > 0 ? numberOfStorageObjects + 1 : numberOfStorageObjects;
	}
}

- (CGFloat)tableView:(UITableView *) tableView heightForHeaderInSection:(NSInteger) section {

	if (section == 0) {
		return 0;
	}
	return 32;
}

- (UIView *)tableView:(UITableView *) tableView viewForHeaderInSection:(NSInteger) section {

	if (section != 0) {
		HistoryHeaderVIew *sectionHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
		self.sectionHeaderView = sectionHeaderView;
		return sectionHeaderView;
	} else {
		return nil;
	}
}

- (void)tableView:(UITableView *) tableView didHighlightRowAtIndexPath:(NSIndexPath *) indexPath {

	if (indexPath.section != 1) {
		return;
	}

    if (![self isLoadingIndex:indexPath]) {
        HistoryTableViewCell *cell = (HistoryTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell changeHighlight:YES];
    }
}

- (void)tableView:(UITableView *) tableView didUnhighlightRowAtIndexPath:(NSIndexPath *) indexPath {

	if (indexPath.section != 1) {
		return;
	}
    
    if (![self isLoadingIndex:indexPath]) {
        HistoryTableViewCell *cell = (HistoryTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell changeHighlight:NO];
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {

    UITableView *tableView = self.tableView;
    NSIndexPath* updatedAtIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section + 1 >= 0 ? indexPath.section + 1 : 0];
    
    switch(type) {

//        case NSFetchedResultsChangeInsert:
//            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:updatedNewIndexPath]
//                             withRowAnimation:UITableViewRowAnimationFade];
//            break;
//
//        case NSFetchedResultsChangeDelete:
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:updatedAtIndexPath]
//                             withRowAnimation:UITableViewRowAnimationFade];
//            break;

        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:updatedAtIndexPath]
                    atIndexPath:updatedAtIndexPath];
            break;

//        case NSFetchedResultsChangeMove:
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:updatedAtIndexPath]
//                             withRowAnimation:UITableViewRowAnimationFade];
//            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:updatedNewIndexPath]
//                             withRowAnimation:UITableViewRowAnimationFade];
//            break;
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *) scrollView {
	DLog(@"scrollViewDidEndDecelerating");

	BOOL isTopAutoScroll = scrollView.contentOffset.y < 0;
	BOOL isBottomAutoScroll = scrollView.contentOffset.y + scrollView.bounds.size.height - scrollView.contentInset.bottom > scrollView.contentSize.height;
	if (!self.mainCell || isTopAutoScroll || isBottomAutoScroll)
		return;
	self.isScrollingAnimation = YES;
	CGFloat diff = [self.mainCell calculateOffsetAfterScroll:scrollView.contentOffset.y];
	[scrollView setContentOffset:CGPointMake (scrollView.contentOffset.x, scrollView.contentOffset.y - diff) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *) scrollView {

	self.lastContentOffset = scrollView.contentOffset.y;
	[self didScrollForheaderCell:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *) aScrollView willDecelerate:(BOOL) decelerate {

	BOOL isTopAutoScroll = aScrollView.contentOffset.y < 0;
	BOOL isBottomAutoScroll = aScrollView.contentOffset.y + aScrollView.bounds.size.height - aScrollView.contentInset.bottom > aScrollView.contentSize.height;
	if (!self.mainCell || isTopAutoScroll || isBottomAutoScroll)
		return;
	self.isScrollingAnimation = YES;
	CGFloat diff = [self.mainCell calculateOffsetAfterScroll:aScrollView.contentOffset.y];
	[aScrollView setContentOffset:CGPointMake (aScrollView.contentOffset.x, aScrollView.contentOffset.y - diff) animated:YES];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *) scrollView {
	self.isScrollingAnimation = NO;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section && ![self isLoadingIndex:indexPath]) {
		[self.delegate didSelectHistoryItemIndexPath:indexPath withItem:self.wallet.historyStorage.historyPrivate[indexPath.row]];
	}
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self isLoadingIndex:indexPath]) {
        LoadingFooterCell* loadingCell = (LoadingFooterCell*)cell;
        [loadingCell startAnimation];
        
        if (!self.isLoadingNow) {
            [self.delegate refreshTableViewDataWithPage:self.currentPage];
            self.isLoadingNow = YES;
        }
    }
}

#pragma mark - Private

- (HeaderCellType)headerCellType {

	if ([self.wallet.unconfirmedBalance isEqualToInt:0] && !self.haveTokens) {
		return HeaderCellTypeWithoutAll;
	}

	if ([self.wallet.unconfirmedBalance isEqualToInt:0]) {
		return HeaderCellTypeWithoutNotCorfirmedBalance;
	}

	if (!self.haveTokens) {
		return HeaderCellTypeWithoutPageControl;
	}

	return HeaderCellTypeAllVisible;
}

- (BOOL)isLoadingIndex:(NSIndexPath*) indexpath {
    
    if (self.shouldShowLoadingCell) {
        return [self.fetchedResultsController fetchedObjects].count == indexpath.row && indexpath.row != 0;
    }
    
    return NO;
}

#pragma mark - Public

- (void)didScrollForheaderCell:(UIScrollView *) scrollView {

	NSIndexPath *headerIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	WalletHeaderCell *headerCell = [self.tableView cellForRowAtIndexPath:headerIndexPath];

	if (!headerCell) {
		return;
	}

	if (self.sectionHeaderView) {
		CGFloat headerHeight = [headerCell getHeaderHeight];
		CGFloat headerPosition = self.sectionHeaderView.frame.origin.y - scrollView.contentOffset.y;
		if (headerPosition <= headerHeight) {
			if ([self.controllerDelegate respondsToSelector:@selector (needShowHeaderForSecondSeciton)]) {
				[self.controllerDelegate needShowHeaderForSecondSeciton];
			}
		} else {
			if ([self.controllerDelegate respondsToSelector:@selector (needHideHeaderForSecondSeciton)]) {
				[self.controllerDelegate needHideHeaderForSecondSeciton];
			}
		}
	}

	CGFloat position = headerCell.frame.origin.y - scrollView.contentOffset.y;
	[headerCell cellYPositionChanged:position];

	if ([headerCell needShowHeader:position]) {
		if ([self.controllerDelegate respondsToSelector:@selector (needShowHeader:)]) {

			[self.controllerDelegate needShowHeader:[headerCell percentForShowHideHeader:position]];
		}
	} else {
		if ([self.controllerDelegate respondsToSelector:@selector (needHideHeader:)]) {
			[self.controllerDelegate needHideHeader:[headerCell percentForShowHideHeader:position]];
		}
	}
}

@end
