//
//  QStoreTableViewCell.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 27.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QStoreCollectionViewSource.h"

@interface QStoreTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

- (void)setCollectionViewSource:(QStoreCollectionViewSource *) source;

+ (CGFloat)getHeightCellForRowCount:(NSInteger) count;

+ (NSString *)getIdentifier;

@end
