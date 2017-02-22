//
//  ApplicationCoordinator.m
//  qtum wallet
//
//  Created by Никита Федоренко on 13.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "ApplicationCoordinator.h"
#import "Appearance.h"
#import "CreatePinRootController.h"
#import "PinViewController.h"
#import "SettingsViewController.h"
#import "TabBarController.h"
#import "UIViewController+Extension.h"
#import "ControllersFactory.h"
#import "StartNavigationCoordinator.h"
#import "LoginCoordinator.h"


#import "ImportKeyViewController.h"

@interface ApplicationCoordinator ()

@property (strong,nonatomic) AppDelegate* appDelegate;
@property (strong,nonatomic) TabBarController* router;
@property (strong,nonatomic) ControllersFactory* controllersFactory;
@property (strong,nonatomic) UIViewController* viewController;
@property (strong,nonatomic) UINavigationController* navigationController;
@property (nonatomic,strong) NSMutableArray *childCoordinators;


@end

@implementation ApplicationCoordinator

#pragma mark - Initialization

+ (instancetype)sharedInstance
{
    static ApplicationCoordinator *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] initUniqueInstance];
    });
    return instance;
}

- (instancetype)initUniqueInstance
{
    self = [super init];
    if (self != nil) {
        _controllersFactory = [ControllersFactory sharedInstance];
    }
    return self;
}

#pragma mark - Privat Methods

-(AppDelegate*)appDelegate{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

#pragma mark - Lazy Getters

- (NSMutableArray *)childCoordinators {
    if (!_childCoordinators) {
        self.childCoordinators = @[].mutableCopy;
    }
    return _childCoordinators;
}

#pragma mark - Start

-(void)start{
    [Appearance setUp];
    if ([[WalletManager sharedInstance] haveWallets] && [WalletManager sharedInstance].PIN) {
        [self startLoginFlow];
    }else{
        [self startAuthFlow];
    }
}

#pragma mark - Navigation


-(void)pushViewController:(UIViewController*) controller animated:(BOOL)animated{
//    [self.router pushViewController:controller animated:animated];
}

-(void)setViewController:(UIViewController*) controller animated:(BOOL)animated{
    [self.router setViewControllers:@[controller] animated:animated];
}

-(void)presentAsModal:(UIViewController*) controller animated:(BOOL)animated{
//    [self.root presentViewController:controller animated:animated completion:nil];
}

#pragma mark - ApplicationCoordinatorDelegate

-(void)coordinatorDidLogin:(LoginCoordinator*)coordinator{
    [self.childCoordinators removeObject:coordinator];
    [self startMainFlow];
}

-(void)coordinatorDidCanceledLogin:(LoginCoordinator*)coordinator{
    [self.childCoordinators removeObject:coordinator];
    [self startAuthFlow];
}

-(void)coordinatorDidAuth:(AuthCoordinator*)coordinator{
    [self.childCoordinators removeObject:coordinator];
    [self startMainFlow];
}


#pragma mark - Presenting Controllers

-(void)showSettings{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self setViewController:viewController animated:NO];
}

-(void)showWallet{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    [self setViewController:viewController animated:NO];
}

-(void)showExportBrainKeyAnimated:(BOOL)animated{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"ExportBrainKeyViewController"];
    [self setViewController:viewController animated:animated];
}

#pragma mark - Flows

-(void)startAuthFlow{
    //TODO create navigation by fabric
    UINavigationController* navigationController = (UINavigationController*)[[ControllersFactory sharedInstance] createAuthNavigationController];
    self.appDelegate.window.rootViewController = navigationController;
    AuthCoordinator* coordinator = [[AuthCoordinator alloc]initWithNavigationViewController:navigationController];
    coordinator.delegate = self;
    [coordinator start];
    [self.childCoordinators addObject:coordinator];
}

-(void)startLoginFlow{
    //TODO create navigation by fabric
    UINavigationController* navigationController = (UINavigationController*)[[ControllersFactory sharedInstance] createAuthNavigationController];
    self.appDelegate.window.rootViewController = navigationController;
    LoginCoordinator* coordinator = [[LoginCoordinator alloc]initWithNavigationViewController:navigationController];
    coordinator.delegate = self;
    [coordinator start];
    [self.childCoordinators addObject:coordinator];
}

-(void)startStartFlowWithAutorization:(BOOL)isAutorized{
    StartNavigationCoordinator* controller = (StartNavigationCoordinator*)[self.controllersFactory createFlowNavigationCoordinator];
    controller.isAutrized = isAutorized;
    self.appDelegate.window.rootViewController = controller;
}


-(void)startChangePinFlow{
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    PinViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"PinViewController"];
//    ChangePinController* changePinRoot = [[ChangePinController alloc]initWithRootViewController:viewController];
//    changePinRoot.changePinCompletesion =  ^(){
//        //[self backToSettings];
//    };
//    viewController.delegate = changePinRoot;
//    viewController.type = OldType;
//    [self presentAsModal:changePinRoot animated:YES];
}

-(void)startWalletFlow{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"StartViewController"];
    UINavigationController* rootNavigation = [[UINavigationController alloc]initWithRootViewController:viewController];
    rootNavigation.navigationBar.hidden = YES;
    self.appDelegate.window.rootViewController = rootNavigation;
}

-(void)startAskPinFlow:(void(^)()) completesion{
}

-(void)startMainFlow{
    TabBarController* controller = (TabBarController*)[self.controllersFactory createTabFlow];
    self.router = controller;
    self.appDelegate.window.rootViewController = controller;
}

-(void)startCreatePinFlowWithCompletesion:(void(^)()) completesion{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PinViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"PinViewController"];
    CreatePinRootController* createPinRoot = [[CreatePinRootController alloc]initWithRootViewController:viewController];
    createPinRoot.createPinCompletesion = completesion;
//    viewController.delegate = createPinRoot;
    viewController.type = CreateType;
    self.appDelegate.window.rootViewController = createPinRoot;
}


@end
