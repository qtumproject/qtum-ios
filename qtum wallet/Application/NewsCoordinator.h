//
//  NewsCoordinator.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 02.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NewsCoordinatorDelegate <NSObject>

@required
-(void)refreshTableViewData;

@end

@protocol TabBarCoordinatorDelegate;

@interface NewsCoordinator : BaseCoordinator <Coordinatorable,NewsCoordinatorDelegate>

@property (weak,nonatomic) id <TabBarCoordinatorDelegate> delegate;

-(instancetype)initWithNavigationController:(UINavigationController*)navigationController;

@end
