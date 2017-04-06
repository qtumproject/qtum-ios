//
//  WalletHistoryDelegateDataSource.h
//  qtum wallet
//
//  Created by Никита Федоренко on 06.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletCoordinator.h"
@class HistoryElement;
@class WalletModel;
@class WalletTypeCollectionDataSourceDelegate;


@protocol ControllerDelegate <NSObject>

- (void)fadeInNavigationBar;
- (void)fadeOutNavigationBar;

@end

@protocol TableViewDelegate <NSObject>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withItem:(HistoryElement*) item;
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath withItem:(HistoryElement*) item;

@end

@interface WalletHistoryDelegateDataSource : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) UITableView* tableView;
@property (strong, nonatomic) WalletModel* wallet;
@property (strong,nonatomic) WalletTypeCollectionDataSourceDelegate* collectionDelegateDataSource;
@property (weak,nonatomic) id <WalletCoordinatorDelegate> delegate;
@property (weak,nonatomic) id <ControllerDelegate> controllerDelegate;

@end
