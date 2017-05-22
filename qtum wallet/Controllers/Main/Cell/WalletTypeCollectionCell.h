//
//  WalletTypeCollectionCell.h
//  qtum wallet
//
//  Created by Никита Федоренко on 06.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletTypeCollectionDataSourceDelegate.h"

static NSString *WalletTypeCollectionCellIdentifire = @"WalletTypeCollectionCellIdentifire";

@interface WalletTypeCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *unconfirmedValue;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeWalletLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *showAddresButton;

@property (weak, nonatomic) id <WalletCollectionCellDelegate> delegate;

-(void)configWithObject:(id) object;

@end
