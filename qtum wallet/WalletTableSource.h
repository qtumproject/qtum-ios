//
//  WalletHistoryDelegateDataSource.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 06.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletCoordinator.h"
#import "WalletHeaderCell.h"
#import "HistoryHeaderVIew.h"

@class HistoryElement;

@protocol ControllerDelegate <NSObject>

@optional
- (void)needShowHeader;
- (void)needHideHeader;
- (void)needShowHeaderForSecondSeciton;
- (void)needHideHeaderForSecondSeciton;

@end

@protocol TableViewDelegate <NSObject>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withItem:(HistoryElement*) item;
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath withItem:(HistoryElement*) item;

@end

@interface WalletTableSource : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) UITableView *tableView;

@property (weak, nonatomic) id <Spendable> wallet;
@property (weak, nonatomic) id <WalletCoordinatorDelegate> delegate;
@property (weak, nonatomic) id <ControllerDelegate> controllerDelegate;

@property (nonatomic) BOOL haveTokens;

@property (nonatomic, weak, readonly) HistoryHeaderVIew *sectionHeaderView;
@property (nonatomic, readonly) CGFloat lastContentOffset;

- (HeaderCellType)headerCellType;

@end
