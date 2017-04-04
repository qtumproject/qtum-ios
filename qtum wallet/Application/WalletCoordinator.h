//
//  WalletCoordinator.h
//  qtum wallet
//
//  Created by Никита Федоренко on 02.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WalletCoordinatorDelegate <NSObject>

@required
-(void)refreshTableViewDataLocal:(BOOL)isLocal fromStart:(BOOL) flag;
-(void)refreshTableViewBalanceLocal:(BOOL)isLocal;
-(void)qrCodeScannedWithDict:(NSDictionary*) dict;
-(void)viewWillAppear;
-(void)showAddressInfo;
-(void)setLastPageForHistory:(NSInteger)lastPage needIncrease:(BOOL) inc;

@end

@protocol TabBarCoordinatorDelegate;

@interface WalletCoordinator : BaseCoordinator <WalletCoordinatorDelegate,Coordinatorable>

@property (weak,nonatomic) id <TabBarCoordinatorDelegate> delegate;

-(instancetype)initWithNavigationController:(UINavigationController*)navigationController;

@end
