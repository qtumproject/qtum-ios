//
//  WalletCoordinator.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 02.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HistoryElement;
@class AbiinterfaceItem;
@class ResultTokenInputsModel;
@protocol Spendable;

@protocol WalletCoordinatorDelegate <NSObject>

@required

// Table reload
- (void)refreshTableViewData;

// Show
- (void)showAddressInfoWithSpendable:(id <Spendable>) spendable;

// Some actions
- (void)didQRCodeScannedWithDict:(NSDictionary*)dict;
- (void)didBackPressed;
- (void)didSelectHistoryItemIndexPath:(NSIndexPath *)indexPath withItem:(HistoryElement*)item;
- (void)didShareTokenButtonPressed;

@end

@protocol TabBarCoordinatorDelegate;

@interface WalletCoordinator : BaseCoordinator <WalletCoordinatorDelegate, Coordinatorable>

@property (weak,nonatomic) id <TabBarCoordinatorDelegate> delegate;

-(instancetype)initWithNavigationController:(UINavigationController*)navigationController;

@end
