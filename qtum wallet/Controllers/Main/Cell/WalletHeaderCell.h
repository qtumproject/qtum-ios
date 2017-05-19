//
//  WalletTypeCellWithCollection.h
//  qtum wallet
//
//  Created by Никита Федоренко on 03.04.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletCoordinator.h"

static NSString *WalletTypeCellWithCollectionIdentifire = @"WalletHeaderCellIdentifire";

@interface WalletHeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *unconfirmedValue;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeWalletLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UILabel *adressValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *showAddresButton;
@property (weak,nonatomic) id <WalletCoordinatorDelegate> delegate;

@end
