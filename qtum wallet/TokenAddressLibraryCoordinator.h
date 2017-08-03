//
//  TokenAddressLibraryCoordinator.h
//  qtum wallet
//
//  Created by Никита Федоренко on 03.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TokenAddressLibraryCoordinator;

@protocol TokenAddressLibraryCoordinatorDelegate <NSObject>

- (void)coordinatorLibraryDidEnd:(TokenAddressLibraryCoordinator*)coordinator;

@end

@interface TokenAddressLibraryCoordinator : BaseCoordinator <Coordinatorable>

@property (weak,nonatomic) id <TokenAddressLibraryCoordinatorDelegate> delegate;
@property (strong, nonatomic) Contract* token;

-(instancetype)initWithNavigationViewController:(UINavigationController*)navigationController;

@end
