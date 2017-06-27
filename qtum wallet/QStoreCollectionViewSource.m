//
//  QStoreCollectionViewSource.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 26.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreCollectionViewSource.h"
#import "QStoreCollectionViewCell.h"

@implementation QStoreCollectionViewSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 26;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QStoreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QStoreCollectionViewCell" forIndexPath:indexPath];
    
    return cell;
}



@end
