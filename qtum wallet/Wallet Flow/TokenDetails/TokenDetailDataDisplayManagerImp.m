//
//  TokenDetailDataDisplayManagerImp.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 12.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "TokenDetailDataDisplayManagerImp.h"
#import "HistoryTableViewCell.h"
#import "LoadingFooterCell.h"
#import "WalletContractHistoryEntity+Extension.h"

@interface TokenDetailDataDisplayManagerImp () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) BOOL shouldShowLoadingCell;
@property (nonatomic) BOOL isLoadingNow;
@property (nonatomic) BOOL isValidDataState;
@property (nonatomic, assign) NSInteger currentPage;

@end

static NSString* fetchedEntity = @"WalletContractHistoryEntity";
static NSInteger batchSize = 25;
static NSString* fetchedSortingProperty = @"dateInerval";
static NSString* historyCellReuseIdentifire = @"HistoryTableViewCell";
static NSString* historyInternalCellReuseIdentifire = @"HistoryTableViewCellInternal";
static NSString* historyCellLoadingReuseIdentifire = @"HistoryTableViewCellLoading";
static NSString* footerLoaderReuseIdentifire = @"LoadingFooterCell";

@implementation TokenDetailDataDisplayManagerImp

@synthesize token;
@synthesize delegate;
@synthesize tableView;
@synthesize emptyPlaceholderView;

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:fetchedEntity inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:fetchedSortingProperty ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    if (self.token.contractAddress.length > 0) {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"contractAddress like %@", self.token.contractAddress];
        [fetchRequest setPredicate:predicate];
    }

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
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    [self fethcFromStart];
}

-(void)fethcFromStart {
    
    self.currentPage = 0;
    self.isValidDataState = NO;
    [self.delegate refreshTableViewDataFromStart];
    self.isLoadingNow = YES;
}

- (void)reloadWithFeching {
    
    self.currentPage += 1;
    NSInteger itemsToShow = self.currentPage * batchSize;
    [self.fetchedResultsController.fetchRequest setFetchLimit:itemsToShow];
    self.shouldShowLoadingCell = itemsToShow < SLocator.contractHistoryFacadeService.totalItems;
    [self.fetchedResultsController performFetch:nil];
    self.isLoadingNow = NO;
    self.isValidDataState = YES;
    [self.tableView reloadData];
}

- (void)failedConnection {
    
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.fetchedResultsController.fetchRequest setFetchLimit:0];
        [weakSelf.fetchedResultsController performFetch:nil];
        weakSelf.shouldShowLoadingCell = NO;
        weakSelf.isLoadingNow = NO;
        weakSelf.isValidDataState = NO;
        [weakSelf.tableView reloadData];
    });
}

- (void)reconnect {
    
    [self fethcFromStart];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if ([self isLoadingIndex:indexPath]) {
        LoadingFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:footerLoaderReuseIdentifire];
        return cell;
    } else {
        
        NSIndexPath* path = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1 >= 0 ? indexPath.section - 1 : 0];
        WalletContractHistoryEntity *entity = [self.fetchedResultsController objectAtIndexPath:path];
        HistoryTableViewCell *cell;
        
        if (!entity.confirmed) {
            cell = [tableView dequeueReusableCellWithIdentifier:historyCellReuseIdentifire];
        }else if (!entity.hasReceipt) {
            cell = [tableView dequeueReusableCellWithIdentifier:historyCellLoadingReuseIdentifire];
        } else if (entity.internal) {
            cell = [tableView dequeueReusableCellWithIdentifier:historyInternalCellReuseIdentifire];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:historyCellReuseIdentifire];
        }
        
        [self configureCell:cell atIndexPath:path withEntity:entity];
        
        return cell;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    if (type == NSFetchedResultsChangeUpdate || type == NSFetchedResultsChangeMove) {
        [self.tableView reloadData];
    }
}

- (void)configureCell:(HistoryTableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath withEntity:(WalletContractHistoryEntity*) entity {
    
    cell.historyElement = entity;
    [cell changeHighlight:NO];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView {
    
    return self.fetchedResultsController.sections.count + [self realNumberOfSections] - 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self isLoadingIndex:indexPath]) {
        LoadingFooterCell* loadingCell = (LoadingFooterCell*)cell;
        [loadingCell startAnimation];
        
        if (!self.isLoadingNow) {
            [self.delegate refreshTableViewDataWithPage:self.currentPage];
            self.isLoadingNow = YES;
        }
    }
}

#pragma mark - Subclassing

-(NSInteger)realNumberOfSections {
    return 1;
}

- (NSInteger)countOfHistoryElement {
    
    NSInteger numberOfStorageObjects = self.fetchedResultsController.fetchedObjects.count;
    self.emptyPlaceholderView.hidden = numberOfStorageObjects > 0 ? YES : NO;
    return self.shouldShowLoadingCell && numberOfStorageObjects > 0 ? numberOfStorageObjects + 1 : numberOfStorageObjects;
}

- (BOOL)isLoadingIndex:(NSIndexPath*) indexpath {
    
    if (self.shouldShowLoadingCell) {
        return [self.fetchedResultsController fetchedObjects].count == indexpath.row && indexpath.row != 0;
    }
    
    return NO;
}

-(id<HistoryElementProtocol>)elementForIndexPath:(NSIndexPath*) indexPath {
    
    if (indexPath.row < self.fetchedResultsController.fetchedObjects.count) {
        return self.fetchedResultsController.fetchedObjects[indexPath.row];
    }
    return nil;
}

- (void)didPressedHistoryElementAtIndexPath:(NSIndexPath*) indexPath {
    
    if (indexPath.row < self.fetchedResultsController.fetchedObjects.count) {
        if ([self.delegate respondsToSelector:@selector(didPressHistoryItemForToken:)]) {
            [self.delegate didPressHistoryItemForToken:self.fetchedResultsController.fetchedObjects[indexPath.row]];
        }
    }
}

@end
