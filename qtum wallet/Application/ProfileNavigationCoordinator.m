//
//  ProfileNavigationCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 26.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "ProfileNavigationCoordinator.h"
#import "PinViewController.h"
#import "LanguageViewController.h"

@interface ProfileNavigationCoordinator () <PinCoordinator, UIGestureRecognizerDelegate>

@property (strong,nonatomic) NSString* pinNew;
@property (strong,nonatomic) NSString* pinOld;
@property (weak,nonatomic) PinViewController* pinController;

@end

@implementation ProfileNavigationCoordinator

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.interactivePopGestureRecognizer.delegate = self;
    self.interactivePopGestureRecognizer.enabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if ([viewController isKindOfClass:[PinViewController class]]) {
        PinViewController* controller = (PinViewController*)viewController;
        controller.type = ConfirmType;
        controller.delegatePin = self;
        self.pinController = controller;
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - PinCoordinator

- (void)confirmPin:(NSString*)pin andCompletision:(void(^)(BOOL success))completision {
    if (!self.pinOld) {
        if ([[WalletManager sharedInstance].PIN isEqualToString:pin]) {
            //old pin confirmed
            self.pinOld = pin;
            [self.pinController setCustomTitle:NSLocalizedString(@"Enter New PIN", "")];
        }else {
            completision(NO);
            [self.pinController actionIncorrectPin];
            [self.pinController setCustomTitle:NSLocalizedString(@"Enter Old PIN", "")];
        }
    } else if(!self.pinNew) {
        //entered new pin
        self.pinNew = pin;
        [self.pinController setCustomTitle:NSLocalizedString(@"Repeat New PIN", "")];

    } else {
        if (self.pinNew == pin) {
            //change pin for new one
            [[WalletManager sharedInstance] storePin:self.pinNew];
            [self popViewControllerAnimated:YES];
            self.pinOld = nil;
            self.pinNew = nil;
        } else {
            //confirming pin failed
            self.pinOld = nil;
            self.pinNew = nil;
            completision(NO);
            [self.pinController actionIncorrectPin];
            [self.pinController setCustomTitle:NSLocalizedString(@"Enter Old PIN", "")];
        }
    }
}


@end
