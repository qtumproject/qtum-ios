//
//  CreatePinRootController.m
//  qtum wallet
//
//  Created by Никита Федоренко on 14.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "CreatePinRootController.h"
#import "ApplicationCoordinator.h"
#import "KeysManager.h"

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
            [[KeysManager sharedInstance] storePin:pin];
            self.createPinCompletesion();
        }
    } else if(self.firstPin) {
        completision(NO);
    } else {
        self.firstPin = pin;
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PinViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"PinViewController"];
        viewController.delegate = self;
        viewController.type = ConfirmType;
        [self setViewControllers:@[viewController] animated:YES];
    }
}

-(void)confilmPinFailed{
    self.firstPin = nil;
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PinViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"PinViewController"];
    viewController.delegate = self;
    viewController.type = CreateType;
    [self setViewControllers:@[viewController] animated:YES];
}

@end
