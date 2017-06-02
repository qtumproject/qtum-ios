//
//  PopUpsManager.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 18.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "PopUpsManager.h"
#import "NoInternetConnectionPopUpViewController.h"
#import "PhotoLibraryPopUpViewController.h"

@interface PopUpsManager() <PopUpViewControllerDelegate>

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
    if (self != nil){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noInternetConnetion) name:NO_INTERNET_CONNECTION_ERROR_KEY object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    BOOL needShow = [self checkAndHideCurrentPopUp:[NoInternetConnectionPopUpViewController class]];
    if (!needShow) {
        return;
    }
    
    NoInternetConnectionPopUpViewController *controller = [self createNoInternetConnetion];
    controller.delegate = delegate;
    self.currentPopUp = controller;
    [controller showFromViewController:presenter animated:YES completion:completion];
}

- (void)showPhotoLibraryPopUp:(id<PopUpWithTwoButtonsViewControllerDelegate>)delegate presenter:(UIViewController *)presenter completion:(void (^)(void))completion
{
    BOOL needShow = [self checkAndHideCurrentPopUp:[PhotoLibraryPopUpViewController class]];
    if (!needShow) {
        return;
    }
    
    PhotoLibraryPopUpViewController *controller = [self createPhotoLibrary];
    controller.delegate = delegate;
    self.currentPopUp = controller;
    [controller showFromViewController:presenter animated:YES completion:completion];
}

- (void)hideCurrentPopUp:(BOOL)animated completion:(void (^)(void))completion
{
    if (self.currentPopUp == nil) return;
    
    [self.currentPopUp hide:animated completion:completion];
    self.currentPopUp = nil;
}

#pragma mark - Private Methods

- (BOOL)checkAndHideCurrentPopUp:(Class)class
{
    if (!self.currentPopUp) return true;
    if ([self.currentPopUp isKindOfClass:class]) return false;
    
    [self hideCurrentPopUp:NO completion:nil];
    return true;
}

- (void)noInternetConnetion{
    UIViewController *root = [UIApplication sharedApplication].delegate.window.rootViewController;
    [self showNoIntenterConnetionsPopUp:self presenter:root completion:nil];
}

#pragma mark - PopUpViewControllerDelegate

- (void)okButtonPressed{
    [self hideCurrentPopUp:YES completion:nil];
}

@end
