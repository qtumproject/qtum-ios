//
//  WalletCoordinator.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 02.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HistoryElement;
@class AbiinterfaceItem;
@class ResultTokenInputsModel;
@protocol Spendable;

@protocol WalletCoordinatorDelegate <NSObject>

@required
- (void)reloadTableViewData;
- (void)refreshTableViewData;
- (void)refreshTableViewBalanceLocal:(BOOL)isLocal;
- (void)qrCodeScannedWithDict:(NSDictionary*) dict;
- (void)viewWillAppear;
- (void)showAddressInfoWithSpendable:(id <Spendable>) spendable;
- (void)pageDidChange:(NSInteger) page;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withItem:(HistoryElement*) item;
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath withItem:(HistoryElement*) item;
- (void)didBackPressed;
- (void)didSelectHistoryItemIndexPath:(NSIndexPath *)indexPath withItem:(HistoryElement*) item;
- (void)didDeselectHistoryItemIndexPath:(NSIndexPath *)indexPath withItem:(HistoryElement*) item;
- (void)didSelectTokenIndexPath:(NSIndexPath *)indexPath withItem:(Token*) item;
- (void)didPressedTokenFunctionWithItem:(Token*) item;
- (void)didDeselectTokenIndexPath:(NSIndexPath *)indexPath withItem:(Token*) item;
- (void)didSelectFunctionIndexPath:(NSIndexPath *)indexPath withItem:(AbiinterfaceItem*) item andToken:(Token*) token;
- (void)didDeselectFunctionIndexPath:(NSIndexPath *)indexPath withItem:(AbiinterfaceItem*) item;
- (void)didCallFunctionWithItem:(AbiinterfaceItem*) item
                       andParam:(NSArray<ResultTokenInputsModel*>*)inputs
                       andToken:(Token*) token;


@end

@protocol TabBarCoordinatorDelegate;

@interface WalletCoordinator : BaseCoordinator <WalletCoordinatorDelegate,Coordinatorable>

@property (weak,nonatomic) id <TabBarCoordinatorDelegate> delegate;

-(instancetype)initWithNavigationController:(UINavigationController*)navigationController;

@end
