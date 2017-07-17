//
//  FavouriteTemplatesCollectionSource.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 17.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "FavouriteTemplatesCollectionSource.h"
#import "FavouriteTemplateCollectionViewCell.h"

const CGFloat FavouriteTemplateCellHeight = 16.0f;
const CGFloat FavouriteTemplateCellMaxWidth = 120.0f;
const CGFloat FavouriteTemplateCellMinWidth = 50.0f;
const CGFloat FavouriteTemplateCellLabelLeft = 3.0f;

@implementation FavouriteTemplatesCollectionSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FavouriteTemplateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:favouriteTemplateCellIdentifire forIndexPath:indexPath];
    
    cell.backgroundColor = [customBlueColor() colorWithAlphaComponent:1.0f - indexPath.row * 0.05f];
    cell.nameLabel.text = [self.templateModels objectAtIndex:indexPath.row].templateName;
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.templateModels.count;
};

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *templateName = [self.templateModels objectAtIndex:indexPath.row].templateName;
    CGSize calculatedSize = [self calculateTextSize:templateName];
    
    if (calculatedSize.width > [self cellMaxWidth]) {
        calculatedSize.width = [self cellMaxWidth];
    }
    if (calculatedSize.width < [self cellMinWidth]) {
        calculatedSize.width = [self cellMinWidth];
    }
    
    return CGSizeMake(calculatedSize.width + [self cellLeftForLabel] * 2.0f, [self cellHeight]);
}

- (CGSize)calculateTextSize:(NSString *)text {
    
    return [text boundingRectWithSize:CGSizeMake([self cellMaxWidth], [self cellHeight])
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{ NSFontAttributeName : [FavouriteTemplateCollectionViewCell getLabelFont] }
                                          context:nil].size;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 3.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 3.0f;
}

- (CGFloat)cellLeftForLabel {
    return FavouriteTemplateCellLabelLeft;
}

- (CGFloat)cellHeight {
    return FavouriteTemplateCellHeight;
}

- (CGFloat)cellMaxWidth {
    return FavouriteTemplateCellMaxWidth;
}

- (CGFloat)cellMinWidth {
    return FavouriteTemplateCellMinWidth;
}

@end
