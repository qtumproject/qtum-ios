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
#import "InformationPopUpViewController.h"
#import "ConfirmPopUpViewController.h"
#import "ErrorPopUpViewController.h"
#import "LoaderPopUpViewController.h"

@interface PopUpsManager() <PopUpViewControllerDelegate>

@property (nonatomic) PopUpViewController *currentPopUp;

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
    NoInternetConnectionPopUpViewController *controller = [[ControllersFactory sharedInstance] createNoInternetConnectionPopUpViewController];
    return controller;
}

- (PhotoLibraryPopUpViewController *)createPhotoLibrary
{
    PhotoLibraryPopUpViewController *controller = [[ControllersFactory sharedInstance] createPhotoLibraryPopUpViewController];
    return controller;
}

- (ErrorPopUpViewController *)createErrorPopUp{
    ErrorPopUpViewController *controller = [[ControllersFactory sharedInstance] createErrorPopUpViewController];
    return controller;
}

- (InformationPopUpViewController *)createInformationPopUp{
    InformationPopUpViewController *controller = [[ControllersFactory sharedInstance] createInformationPopUpViewController];
    return controller;
}

- (ConfirmPopUpViewController *)createConfirmPopUp{
    ConfirmPopUpViewController *controller = [[ControllersFactory sharedInstance] createConfirmPopUpViewController];
    return controller;
}

- (LoaderPopUpViewController *)createLoaderPopUp{
    LoaderPopUpViewController *controller = [[ControllersFactory sharedInstance] createLoaderViewController];
    return controller;
}

#pragma mark - Public Methods

- (void)showLoaderPopUp {
    BOOL needShow = [self checkAndHideCurrentPopUp:[LoaderPopUpViewController class] withContent:nil];
    if (!needShow) {
        return;
    }
    
    LoaderPopUpViewController *controller = [self createLoaderPopUp];
    self.currentPopUp = controller;
    UIViewController *root = [UIApplication sharedApplication].delegate.window.rootViewController;
    [controller showFromViewController:root animated:YES completion:nil];
}

- (void)dismissLoader {
    if ([self.currentPopUp isKindOfClass:[LoaderPopUpViewController class]]) {
        [self hideCurrentPopUp:YES completion:nil];
    }
}

- (void)showNoIntenterConnetionsPopUp:(id<PopUpViewControllerDelegate>)delegate presenter:(UIViewController *)presenter  completion:(void (^)(void))completion
{
    BOOL needShow = [self checkAndHideCurrentPopUp:[NoInternetConnectionPopUpViewController class] withContent:nil];
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
    BOOL needShow = [self checkAndHideCurrentPopUp:[PhotoLibraryPopUpViewController class] withContent:nil];
    if (!needShow) {
        return;
    }
    
    PhotoLibraryPopUpViewController *controller = [self createPhotoLibrary];
    controller.delegate = delegate;
    self.currentPopUp = controller;
    [controller showFromViewController:presenter animated:YES completion:completion];
}

- (void)showErrorPopUp:(id<PopUpWithTwoButtonsViewControllerDelegate>)delegate withContent:(PopUpContent *)content presenter:(UIViewController *)presenter completion:(void (^)(void))completion{
    
    BOOL needShow = [self checkAndHideCurrentPopUp:[ErrorPopUpViewController class] withContent:content];
    if (!needShow) {
        return;
    }
    
    ErrorPopUpViewController *controller = [self createErrorPopUp];
    controller.delegate = delegate;
    [controller setContent:content];
    self.currentPopUp = controller;
    [controller showFromViewController:presenter animated:YES completion:completion];
}

- (void)showInformationPopUp:(id<PopUpViewControllerDelegate>)delegate withContent:(PopUpContent *)content presenter:(UIViewController *)presenter completion:(void (^)(void))completion{
    
    BOOL needShow = [self checkAndHideCurrentPopUp:[InformationPopUpViewController class] withContent:content];
    if (!needShow) {
        return;
    }
    
    InformationPopUpViewController *controller = [self createInformationPopUp];
    controller.delegate = delegate;
    [controller setContent:content];
    self.currentPopUp = controller;
    [controller showFromViewController:presenter animated:YES completion:completion];
}

- (void)showConfirmPopUp:(id<PopUpWithTwoButtonsViewControllerDelegate>)delegate withContent:(PopUpContent *)content presenter:(UIViewController *)presenter completion:(void (^)(void))completion{
    
    BOOL needShow = [self checkAndHideCurrentPopUp:[ConfirmPopUpViewController class] withContent:content];
    if (!needShow) {
        return;
    }
    
    ConfirmPopUpViewController *controller = [self createConfirmPopUp];
    controller.delegate = delegate;
    [controller setContent:content];
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

- (BOOL)checkAndHideCurrentPopUp:(Class)class withContent:(PopUpContent *)content
{
    if (!self.currentPopUp) return true;
    BOOL contentEqual = [self.currentPopUp getContent] ? [[self.currentPopUp getContent] isEqual:content] : true;
    if ([self.currentPopUp isKindOfClass:class] && contentEqual) return false;
    
    [self hideCurrentPopUp:NO completion:nil];
    return true;
}

- (void)noInternetConnetion{
    UIViewController *root = [UIApplication sharedApplication].delegate.window.rootViewController;
    [self showNoIntenterConnetionsPopUp:self presenter:root completion:nil];
}

#pragma mark - PopUpViewControllerDelegate

- (void)okButtonPressed:(PopUpViewController *)sender{
    [self hideCurrentPopUp:YES completion:nil];
}

@end
