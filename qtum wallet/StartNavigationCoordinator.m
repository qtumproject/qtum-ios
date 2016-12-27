//
//  StartNavigationCoordinator.m
//  qtum wallet
//
//  Created by Никита Федоренко on 27.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "StartNavigationCoordinator.h"
#import "PinViewController.h"

@interface StartNavigationCoordinator ()

@property (strong,nonatomic) NSString* firstPin;

@end

@implementation StartNavigationCoordinator

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isKindOfClass:[PinViewController class]]) {
        PinViewController* controller = (PinViewController*)viewController;
        controller.type = CreateType;
        controller.delegate = self;
    }
    [super pushViewController:viewController animated:animated];
}

-(void)confirmPin:(NSString*)pin andCompletision:(void(^)(BOOL success)) completision{
    if (self.firstPin && [self.firstPin isEqualToString:pin]) {
        completision(YES);
        if (self.createPinCompletesion) {
            [[WalletManager sharedInstance] storePin:pin];
            self.createPinCompletesion();
        }
    } else if(self.firstPin) {
        completision(NO);
    } else {
        self.firstPin = pin;
    }
}

@end
