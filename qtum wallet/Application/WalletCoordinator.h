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
-(void)refreshTableViewData;
-(void)refreshTableViewBalance;
-(void)qrCodeScannedWithDict:(NSDictionary*) dict;

@end

@protocol TabBarCoordinatorDelegate;

@interface WalletCoordinator : BaseCoordinator <WalletCoordinatorDelegate,Coordinatorable>

@property (weak,nonatomic) id <TabBarCoordinatorDelegate> delegate;

-(instancetype)initWithNavigationController:(UINavigationController*)navigationController;

@end
