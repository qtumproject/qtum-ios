//
//  QStoreTableViewCell.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 27.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreTableViewCell.h"

@interface QStoreTableViewCell ()

@property (nonatomic) QStoreCollectionViewSource *collectionSource;

@end

@implementation QStoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCollectionViewSource:(QStoreCollectionViewSource *)source {
    self.collectionSource = source;
    self.collectionView.delegate = source;
    self.collectionView.dataSource = source;
    
    [self.collectionView reloadData];
    
    [self.collectionView setDecelerationRate:0.8];
}

+ (CGFloat)getHeightCellForRowCount:(NSInteger)count {
    CGFloat heightCell = 130.0f;
    CGFloat spaceBetweenRows = 2.0f;
    CGFloat headerHeight = 33.0f;
    
    return heightCell * count + spaceBetweenRows * (count - 1) + headerHeight;
}

+ (NSString *)getIdentifier {
    return @"QStoreTableViewCell";
}

@end
