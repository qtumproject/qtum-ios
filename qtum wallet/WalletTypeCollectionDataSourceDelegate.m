//
//  WalletTypeCollectionDataSourceDelegate.m
//  qtum wallet
//
//  Created by Никита Федоренко on 03.04.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "WalletTypeCollectionDataSourceDelegate.h"
#import "WalletTypeCollectionCell.h"

@interface WalletTypeCollectionDataSourceDelegate ()

@property (assign, nonatomic) NSInteger currentIndex;

@end

@implementation WalletTypeCollectionDataSourceDelegate

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.wallets.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WalletTypeCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:WalletTypeCollectionCellIdentifire forIndexPath:indexPath];
    [cell configWithObject:self.wallets[indexPath.row]];
    cell.delegate = self;
    return cell;
}

#pragma mark - UICollectionViewDelegate


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 211.5);
}

#pragma mark - WalletCollectionCellDelegate

-(void)showAddressInfo{
    [self.delegate showAddressInfo];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(WalletTypeCollectionCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
   // [self.delegate pageDidChange:self.currentIndex];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    float currentPage = scrollView.contentOffset.x / pageWidth;
    
    if (0.0f != fmodf(currentPage, 1.0f)) {
        self.currentIndex = currentPage + 1;
    } else {
        self.currentIndex = currentPage;
    }
    [self.delegate pageDidChange:self.currentIndex];
}


@end
