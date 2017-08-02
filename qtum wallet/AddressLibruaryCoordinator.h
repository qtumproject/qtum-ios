//
//  AddressLibruaryCoordinator.h
//  qtum wallet
//
//  Created by Никита Федоренко on 02.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AddressLibruaryCoordinator;

@protocol AddressLibruaryCoordinator <NSObject>

- (void)coordinatorLibraryDidEnd:(AddressLibruaryCoordinator*)coordinator;

@end

@interface AddressLibruaryCoordinator : BaseCoordinator <Coordinatorable>

@property (weak,nonatomic) id <AddressLibruaryCoordinator> delegate;

-(instancetype)initWithNavigationViewController:(UINavigationController*)navigationController;

@end
