//
//  CustomWordsLayout.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.01.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "CustomWordsLayout.h"

@implementation CustomWordsLayout

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray<__kindof UICollectionViewLayoutAttributes *> *attributesForElementsInRect = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray<__kindof UICollectionViewLayoutAttributes *> *newAttributesForElementsInRect = @[].mutableCopy;
    CGFloat leftMargin = 0;
    
    for (UICollectionViewLayoutAttributes* attributes in attributesForElementsInRect) {
        
        if (attributes.frame.origin.x == self.sectionInset.left) {
            leftMargin = self.sectionInset.left;
        } else {
            CGRect newLeftAlignedFrame = attributes.frame;
            newLeftAlignedFrame.origin.x = leftMargin;
            attributes.frame = newLeftAlignedFrame;
        }
        
        
        leftMargin+= attributes.frame.size.width;
        
        [newAttributesForElementsInRect addObject:attributes];
    }
    
    return newAttributesForElementsInRect.copy;
}

@end
