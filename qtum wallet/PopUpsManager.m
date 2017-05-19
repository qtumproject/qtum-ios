//
//  PopUpsManager.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "PopUpsManager.h"
#import "NoInternetConnectionPopUpViewController.h"
#import "PhotoLibraryPopUpViewController.h"

@interface PopUpsManager()

@property (nonatomic, weak) PopUpViewController *currentPopUp;

@end

@implementation PopUpsManager

#pragma mark - Instance

+ (instancetype)sharedInstance
{
    static PopUpsManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] initUniqueInstance];
    });
    return instance;
}

- (instancetype)initUniqueInstance
{
    self = [super init];
    if (self != nil) { }
    return self;
}

#pragma mark - Creation of pop-up

- (NoInternetConnectionPopUpViewController *)createNoInternetConnetion
{
    NoInternetConnectionPopUpViewController *controller = [[ControllersFactory sharedInstance] createNoInternetConnectionController];
    return controller;
}

- (PhotoLibraryPopUpViewController *)createPhotoLibrary
{
    PhotoLibraryPopUpViewController *controller = [[ControllersFactory sharedInstance] createPhotoLibraryController];
    return controller;
}

#pragma mark - Public Methods

- (void)showNoIntenterConnetionsPopUp:(id<PopUpViewControllerDelegate>)delegate presenter:(UIViewController *)presenter  completion:(void (^)(void))completion
{
    [self checkAndHideCurrentPopUp:[NoInternetConnectionPopUpViewController class]];
    
    NoInternetConnectionPopUpViewController *controller = [self createNoInternetConnetion];
    controller.delegate = delegate;
    self.currentPopUp = controller;
    [controller showFromViewController:presenter animated:YES completion:completion];
}

- (void)showPhotoLibraryPopUp:(id<PopUpWithTwoButtonsViewControllerDelegate>)delegate presenter:(UIViewController *)presenter completion:(void (^)(void))completion
{
    [self checkAndHideCurrentPopUp:[PhotoLibraryPopUpViewController class]];
    
    PhotoLibraryPopUpViewController *controller = [self createPhotoLibrary];
    controller.delegate = delegate;
    self.currentPopUp = controller;
    [controller showFromViewController:presenter animated:YES completion:completion];
}

- (void)hideCurrentPopUp:(BOOL)animated completion:(void (^)(void))completion
{
    if (self.currentPopUp == nil) return;
    
    [self.currentPopUp hide:animated completion:completion];
}

#pragma mark - Private Methods

- (void)checkAndHideCurrentPopUp:(Class)class
{
    if (self.currentPopUp == nil) return;
    if ([self.currentPopUp isKindOfClass:class]) return;
    
    [self hideCurrentPopUp:NO completion:nil];
}

@end
