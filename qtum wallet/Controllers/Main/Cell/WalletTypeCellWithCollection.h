//
//  WalletTypeCellWithCollection.h
//  qtum wallet
//
//  Created by Никита Федоренко on 03.04.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *WalletTypeCellWithCollectionIdentifire = @"WalletTypeCellWithCollectionIdentifire";

@interface WalletTypeCellWithCollection : UITableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
