//
//  BaseRouter.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 28.11.2017.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "BaseRouter.h"

@interface BaseRouter ()

@property (strong, nonatomic) UINavigationController* rootController;

@end


@implementation BaseRouter

- (instancetype)initWithNavigationController:(UINavigationController*) navigationController {

    self = [super init];

    if (self) {
        _rootController = navigationController;
    }
    return self;
}

#pragma mark - BaseRouterProtocol

- (void)pushOutput:(NSObject <Presentable> *)output animated:(BOOL)animated {
    
    UIViewController* controller = [output toPresent];
    
    if (controller) {
        [self.rootController pushViewController:controller animated:animated];
    } else {
        NSAssert(controller, @"Controller must be not nil");
    }
}

- (void)pushOutput:(NSObject <Presentable> *)output {
    
    [self pushOutput:output animated:NO];
}

- (void)presenteOutput:(NSObject <Presentable> *)output animated:(BOOL)animated {
    
    UIViewController* controller = [output toPresent];
    
    if (controller) {
        [self.rootController presentViewController:controller animated:animated completion:nil];
    } else {
        NSAssert(controller, @"Controller must be not nil");
    }
}

- (void)presenteOutput:(NSObject <Presentable> *)output {
    
    [self presenteOutput:output animated:NO];
}

- (void)popOutputAnimated:(BOOL)animated {
    
    [self.rootController popViewControllerAnimated:animated];
}

- (void)popOutput {
    
    [self popOutputAnimated:NO];
}

- (void)setRootOutput:(NSObject <Presentable> *)output {
    
    UIViewController* controller = [output toPresent];
    
    if (controller) {
        [self.rootController setViewControllers:@[controller]];
    } else {
        NSAssert(controller, @"Controller must be not nil");
    }
}

- (void)popToRoot {
    [self popOutputAnimated:NO];
}

- (void)popToRootAnimated:(BOOL)animated {
    [self.rootController popToRootViewControllerAnimated:animated];
}

@end
