//
//  FavouriteTemplatesCollectionSource.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 17.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "FavouriteTemplatesCollectionSource.h"
#import "FavouriteTemplateCollectionViewCell.h"

const CGFloat FavouriteTemplateCellHeight = 16.0f;
const CGFloat FavouriteTemplateCellMaxWidth = 120.0f;
const CGFloat FavouriteTemplateCellMinWidth = 50.0f;
const CGFloat FavouriteTemplateCellLabelLeft = 3.0f;
const CGFloat MinSpases = 3.0f;

@implementation FavouriteTemplatesCollectionSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FavouriteTemplateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:favouriteTemplateCellIdentifire forIndexPath:indexPath];
    
    cell.nameLabel.text = [self.templateModels objectAtIndex:indexPath.row].templateName;
    if ([self.activeTemplate isEqual:self.templateModels[indexPath.row]]) {
        [cell setSelected:YES];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TemplateModel* template = self.templateModels[indexPath.row];
    
    if ([template isEqual:self.activeTemplate]) {
        
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
        self.activeTemplate = nil;
        [self.delegate didResetToDefaults:self];
    } else {
        self.activeTemplate = template;
        [collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [self.delegate didSelectTemplate:template sender:self];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell setSelected:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger currentIndex = 0;
    for (NSInteger i = 0; i < self.templateModels.count; i++) {
        if ([self.activeTemplate isEqual:[self.templateModels objectAtIndex:i]]) {
            currentIndex = i;
        }
    }
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    if (self.activeTemplate) {
        [collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        if (currentIndex != indexPath.row) {
            [cell setSelected:NO];
        }
    } else {
        [cell setSelected:NO];
    }
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
    
    return [self minSpases];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return [self minSpases];
}

#pragma mark - Setters

- (void)setActiveTemplate:(TemplateModel *)activeTemplate {
    
    _activeTemplate = activeTemplate;
    [self.collectionView reloadData];
}

#pragma mark - Sizes

- (CGFloat)minSpases {
    return MinSpases;
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
