//
//  CreatePinRootController.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 14.12.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "CreatePinRootController.h"

@interface CreatePinRootController () 

@property (strong,nonatomic) NSString* firstPin;

@end

@implementation CreatePinRootController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - PinCoordinator

-(void)confirmPin:(NSString*)pin andCompletision:(void(^)(BOOL success)) completision{
    
    if (self.firstPin && [self.firstPin isEqualToString:pin]) {
        if (self.createPinCompletesion) {
            [SLocator.walletManager storePin:pin];
            self.createPinCompletesion();
        }
    } else if(self.firstPin) {
        completision(NO);
    } else {
        self.firstPin = pin;
        [self showNewPinControllerWithType:ConfirmType];
    }
}

-(void)setAnimationState:(BOOL)isAnimating{
    self.animating = isAnimating;
}

#pragma mark - Private Methods

-(void)resignFirstResponderPin{
    for (UIViewController* vc in self.viewControllers) {
        [vc.view endEditing:YES];
    }
}

-(void)confilmPinFailed{
    self.firstPin = nil;
    [self showNewPinControllerWithType:EnterType];
}

-(void)showNewPinControllerWithType:(PinType) type {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PinViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"PinViewController"];
    viewController.type = type;
    if (!self.animating) {
        self.animating = YES;
        [self setViewControllers:@[viewController] animated:NO];
    }
}

@end
