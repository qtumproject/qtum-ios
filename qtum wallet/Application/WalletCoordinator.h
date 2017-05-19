//
//  WalletCoordinator.h
//  qtum wallet
//
//  Created by Никита Федоренко on 02.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HistoryElement;

@protocol WalletCoordinatorDelegate <NSObject>

@required
- (void)reloadTableViewData;
- (void)refreshTableViewData;
- (void)refreshTableViewBalanceLocal:(BOOL)isLocal;
- (void)qrCodeScannedWithDict:(NSDictionary*) dict;
- (void)viewWillAppear;
- (void)showAddressInfo;
- (void)pageDidChange:(NSInteger) page;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withItem:(HistoryElement*) item;
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath withItem:(HistoryElement*) item;
- (void)didBackPressed;

@end

@protocol TabBarCoordinatorDelegate;

@interface WalletCoordinator : BaseCoordinator <WalletCoordinatorDelegate,Coordinatorable>

@property (weak,nonatomic) id <TabBarCoordinatorDelegate> delegate;

-(instancetype)initWithNavigationController:(UINavigationController*)navigationController;

@end
