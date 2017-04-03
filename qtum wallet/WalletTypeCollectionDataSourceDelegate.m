//
//  WalletTypeCollectionDataSourceDelegate.m
//  qtum wallet
//
//  Created by Никита Федоренко on 03.04.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "WalletTypeCollectionDataSourceDelegate.h"
#import "WalletTypeCollectionCell.h"

@implementation WalletTypeCollectionDataSourceDelegate

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WalletTypeCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:WalletTypeCollectionCellIdentifire forIndexPath:indexPath];
    [cell configWithObject:self.wallet];
    cell.delegate = self;
    return cell;
}

#pragma mark - UICollectionViewDelegate


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 212);
}

#pragma mark - WalletCollectionCellDelegate

-(void)showAddressInfo{
    [self.delegate showAddressInfo];
}


@end
