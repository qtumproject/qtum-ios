//
//  CreateTokenCoordinator.m
//  qtum wallet
//
//  Created by Никита Федоренко on 03.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "CreateTokenCoordinator.h"

@interface CreateTokenCoordinator ()

@property (strong,nonatomic) UINavigationController* navigationController;

@end

@implementation CreateTokenCoordinator

-(instancetype)initWithNavigationController:(UINavigationController*)navigationController{
    self = [super init];
    if (self) {
        _navigationController = navigationController;
    }
    return self;
}

#pragma mark - Coordinatorable

-(void)start{
//    SubscribeTokenViewController* controller = (SubscribeTokenViewController*)[[ControllersFactory sharedInstance] createSubscribeTokenViewController];
//    [self.navigationController pushViewController:controller animated:YES];

}

@end
