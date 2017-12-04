//
//  TokenAddressLibraryCoordinator.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TokenAddressLibraryCoordinator;

@protocol TokenAddressLibraryCoordinatorDelegate <NSObject>

- (void)coordinatorLibraryDidEnd:(TokenAddressLibraryCoordinator *) coordinator;

- (void)coordinatorLibraryDidEnd:(TokenAddressLibraryCoordinator *) coordinator withQrCodeItem:(SendInfoItem *) item;

@end

@interface TokenAddressLibraryCoordinator : BaseCoordinator <Coordinatorable>

@property (weak, nonatomic) id <TokenAddressLibraryCoordinatorDelegate> delegate;
@property (strong, nonatomic) Contract *token;

- (instancetype)initWithNavigationViewController:(UINavigationController *) navigationController;

@end
