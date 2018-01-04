//
//  ConfirmPassphraseViewController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.01.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "ConfirmPassphraseViewController.h"

#import "ConfirmBorderedView.h"

@interface ConfirmPassphraseViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *choosenCollectionViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *choosenCollectionHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *exampleCollectionViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@property (strong, nonatomic) NSArray *choosenWords;
@property (strong, nonatomic) NSArray *exampleWords;

@property (strong, nonatomic) NSOperationQueue *animationQueue;
@property (weak, nonatomic) IBOutlet ConfirmBorderedView *choosedWordsView;

@property (assign, nonatomic) BOOL wordsProcessed;

@end

@implementation ConfirmPassphraseViewController

static NSInteger minCollectionSize = 107;

@synthesize delegate = _delegate, bkWords = _bkWords;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self configLocalization];
    [self configCellsFromNibs];
    
    self.animationQueue = [NSOperationQueue mainQueue];
    
    [self reloadCollections];
}

#pragma mark - Custom Accessors

-(NSArray*)choosenWords {
    
    if (!_choosenWords) {
        _choosenWords = @[];
    }
    return _choosenWords;
}

-(NSArray*)exampleWords {
    
    if (!_exampleWords) {
        _exampleWords = @[];
    }
    return _exampleWords;
}

-(void)setBkWords:(NSArray *)bkWords {
    self.exampleWords = bkWords;
}

#pragma mark - Output

-(void)failedRemindWords {
    
    [self.choosedWordsView setFailedState:YES];
    self.errorLabel.hidden = NO;
    self.wordsProcessed = NO;
}

#pragma mark - Private Methods

-(void)clearFailedState {
    
    [self.choosedWordsView setFailedState:NO];
    self.errorLabel.hidden = YES;
}

- (void)resizeCollections {
    CGFloat collectionContentHeight = self.choosenCollectionView.contentSize.height;
    self.choosenCollectionHeight.constant = collectionContentHeight > minCollectionSize ? collectionContentHeight : minCollectionSize;
    
    CGFloat exampleCollectionContentHeight = self.exampleCollectionView.contentSize.height;
    self.exampleCollectionViewHeight.constant = exampleCollectionContentHeight > minCollectionSize ? exampleCollectionContentHeight : minCollectionSize;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

-(void)viewDidLayoutSubviews {
    
    [self resizeCollections];
}

#pragma mark - Actions

-(void)reloadCollections {
    
    [self.choosenCollectionView reloadData];
}

-(void)addWordToChoosenWithIndex:(NSIndexPath*) indexPath {
    
    __weak __typeof (self) weakSelf = self;
    
    [self.animationQueue cancelAllOperations];
    
    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    
    __weak NSBlockOperation *weakOperation = operation;
    
    [operation addExecutionBlock:^{
        
        if (weakOperation.isCancelled) {
            return;
        }
        
        NSString* word = weakSelf.exampleWords[indexPath.row];
        
        [weakSelf.exampleCollectionView performBatchUpdates:^{
            
            NSMutableArray* mutableCopy = [[weakSelf exampleWords] mutableCopy];
            [mutableCopy removeObjectAtIndex:indexPath.row];
            [weakSelf.exampleCollectionView deleteItemsAtIndexPaths:@[indexPath]];
            weakSelf.exampleWords = [mutableCopy copy];
            
        } completion:^(BOOL finished) {
            
            [weakSelf.choosenCollectionView performBatchUpdates:^{
                
                NSMutableArray* mutableCopy = [[weakSelf choosenWords] mutableCopy];
                [mutableCopy addObject:word];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.choosenWords.count inSection:0];
                [weakSelf.choosenCollectionView insertItemsAtIndexPaths:@[indexPath]];
                weakSelf.choosenWords = [mutableCopy copy];
                
            } completion:^(BOOL finished) {
                
                [weakSelf resizeCollections];
                
                if (weakSelf.exampleWords.count == 0){
                    [weakSelf actionEnterWords];
                }
            }];
        }];
        
    }];
    
    [self.animationQueue addOperation:operation];
}

-(void)removeWordFromChoosenWithIndex:(NSIndexPath*) indexPath {
    
    __weak __typeof(self) weakSelf = self;
    
    [self.animationQueue cancelAllOperations];

    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    
    __weak NSBlockOperation *weakOperation = operation;
    
    [operation addExecutionBlock:^{
        
        if (weakOperation.isCancelled) {
            return;
        }
        
        NSString* word = weakSelf.choosenWords[indexPath.row];
        
        [weakSelf.choosenCollectionView performBatchUpdates:^{
            
            NSMutableArray* mutableCopy = [[weakSelf choosenWords] mutableCopy];
            [mutableCopy removeObjectAtIndex:indexPath.row];
            [weakSelf.choosenCollectionView deleteItemsAtIndexPaths:@[indexPath]];
            weakSelf.choosenWords = [mutableCopy copy];
            
        } completion:^(BOOL finished) {
            
            [weakSelf.exampleCollectionView performBatchUpdates:^{
                
                NSMutableArray* mutableCopy = [[weakSelf exampleWords] mutableCopy];
                [mutableCopy addObject:word];
                NSIndexPath *indexPath =[NSIndexPath indexPathForRow:weakSelf.exampleWords.count inSection:0];
                [weakSelf.exampleCollectionView insertItemsAtIndexPaths:@[indexPath]];
                weakSelf.exampleWords = [mutableCopy copy];
                
            } completion:^(BOOL finished) {
                [weakSelf resizeCollections];
            }];
        }];
        
    }];
    
    [self.animationQueue addOperation:operation];
}

- (IBAction)actionReset:(id)sender {
    
    __weak __typeof(self) weakSelf = self;
    
    [self.animationQueue cancelAllOperations];
    
    [self clearFailedState];

    NSBlockOperation *operation = [[NSBlockOperation alloc] init];
    
    __weak NSBlockOperation *weakOperation = operation;
    
    [operation addExecutionBlock:^{
        
        if (weakOperation.isCancelled) {
            return;
        }
        
        NSArray* choosenWords = weakSelf.choosenWords;
        NSMutableArray<NSIndexPath *> * indexesForDeleting = @[].mutableCopy;
        NSMutableArray<NSIndexPath *> * indexesForInserting = @[].mutableCopy;
        
        for (int i = 0; i < choosenWords.count; i++) {
            
            NSIndexPath *indexPathForDeleting = [NSIndexPath indexPathForRow:i inSection:0];
            [indexesForDeleting addObject:indexPathForDeleting];
            
            NSIndexPath *indexPathForInserting = [NSIndexPath indexPathForRow:i + weakSelf.exampleWords.count inSection:0];
            [indexesForInserting addObject:indexPathForInserting];
        }
        
        [weakSelf.choosenCollectionView performBatchUpdates:^{
            
            [weakSelf.choosenCollectionView deleteItemsAtIndexPaths:indexesForDeleting];
            weakSelf.choosenWords = @[];
            
        }  completion:^(BOOL finished) {
            [weakSelf resizeCollections];
        }];
        
        [weakSelf.exampleCollectionView performBatchUpdates:^{
            
            [weakSelf.exampleCollectionView insertItemsAtIndexPaths:indexesForInserting];
            weakSelf.exampleWords = [weakSelf.exampleWords arrayByAddingObjectsFromArray:choosenWords];
            
        } completion:^(BOOL finished) {
            [weakSelf resizeCollections];
        }];
    }];
    
    [self.animationQueue addOperation:operation];
}

-(void)actionEnterWords {
    
    if ([self.delegate respondsToSelector:@selector(didEnterWords:)] && !self.wordsProcessed) {
        self.wordsProcessed = YES;
        [self.delegate didEnterWords:self.choosenWords];
    }
}

- (IBAction)actionBackPressed:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didBackPressed)]) {
        [self.delegate didBackPressed];
    }
}

#pragma mark - Configuration

- (void)configLocalization {
    self.titleTextLabel.text = NSLocalizedString(@"Confirm Passphrase", @"Confirm Passphrase Controllers Title");
    self.titleLabel.text = NSLocalizedString(@"Please put the words from passphrase into correct order:", @"Confirm Passphrase title label");
    self.errorLabel.text = NSLocalizedString(@"The passphrase is not correct. Please click \"Reset all\" to clear the field and try again", @"Confirm Passphrase error text");
    self.noteLabel.text = NSLocalizedString(@"Note that you won’t be able to restore  your wallet without Passphrase and all funds can be lost.", @"Confirm Passphrase note text");
    [self.resetButton setTitle:NSLocalizedString(@"RESET ALL", @"Confirm Passphrase RESET ALL button") forState:UIControlStateNormal];
}

- (UICollectionViewCell*)configureChoosenCell:(ConfirmWordCollectionViewCell*) cell withIndexPath:(NSIndexPath*) indexPath {
    cell.textLabel.text = self.choosenWords[indexPath.row];
    return cell;
}

- (UICollectionViewCell*)configureExampleCell:(ExampleWordCollectionViewCell*) cell withIndexPath:(NSIndexPath*) indexPath {
    cell.textLabel.text = self.exampleWords[indexPath.row];
    return cell;
}

-(void)configCellsFromNibs {
    
    [self.choosenCollectionView registerNib:[UINib nibWithNibName:@"ConfirmWordCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:confirmWordCollectionViewCellIdentifire];
    [self.exampleCollectionView registerNib:[UINib nibWithNibName:@"ExampleWordCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:exampleWordCollectionViewCellIdentifire];
    
    self.sizingCellForChoose = [[UINib nibWithNibName:@"ConfirmWordCollectionViewCell" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
    self.sizingCellForExample = [[UINib nibWithNibName:@"ExampleWordCollectionViewCell" bundle:nil] instantiateWithOwner:nil options:nil].firstObject;
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([collectionView isEqual:self.choosenCollectionView]) {
        return self.choosenWords.count;
    }
    return self.exampleWords.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([collectionView isEqual:self.choosenCollectionView]) {
        ConfirmWordCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:confirmWordCollectionViewCellIdentifire forIndexPath:indexPath];
        [self configureChoosenCell:cell withIndexPath:indexPath];
        return cell;
    } else {
        
        ExampleWordCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:exampleWordCollectionViewCellIdentifire forIndexPath:indexPath];
        [self configureExampleCell:cell withIndexPath:indexPath];
        return cell;
    }

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell* cell;
    
    if ([collectionView isEqual:self.choosenCollectionView]) {
        cell = self.sizingCellForChoose;
        [self configureChoosenCell:self.sizingCellForChoose withIndexPath:indexPath];
    } else {
        
        cell = self.sizingCellForExample;
        [self configureExampleCell:self.sizingCellForExample withIndexPath:indexPath];
    }
    
    return [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([collectionView isEqual:self.choosenCollectionView]) {
        [self clearFailedState];
        [self removeWordFromChoosenWithIndex:indexPath];
    } else {
        
        [self addWordToChoosenWithIndex:indexPath];
    }
}

@end
