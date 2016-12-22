//
//  ApplicationCoordinator.m
//  qtum wallet
//
//  Created by Никита Федоренко on 13.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "ApplicationCoordinator.h"
#import "KeysManager.h"
#import "Appearance.h"
#import "RootViewController.h"
#import "ContentController.h"
#import "CreatePinRootController.h"
#import "PinViewController.h"
#import "AskPinController.h"
#import "SettingsViewController.h"
#import "ChangePinController.h"
#import "ImportKeyCoordinator.h"

@interface ApplicationCoordinator ()

@property (strong,nonatomic) AppDelegate* appDelegate;
@property (strong,nonatomic) RootViewController* root;
@property (strong,nonatomic) ContentController* router;

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
    if (self != nil) { }
    return self;
}

#pragma mark - Privat Methods

-(AppDelegate*)appDelegate{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

#pragma mark - Start Flow

-(void)start{
    [Appearance setUp];

    if ([KeysManager sharedInstance].keys.count && [KeysManager sharedInstance].PIN) {
        [self startAskPinFlow:nil];
    }else{
        [self startWalletFlow];
    }
}

-(UIViewController*)congigSideMenuWithFirstController:(UIViewController*) controller{
    ContentController *navigationController = [[ContentController alloc] initWithRootViewController:controller];
    RootViewController *mainViewController = [RootViewController new];
    mainViewController.rootViewController = navigationController;
    
    [mainViewController setupWithPresentationStyle:LGSideMenuPresentationStyleSlideAbove type:0];
    self.root = mainViewController;
    self.router = navigationController;

    return mainViewController;
}

-(void)shoudShowMenu:(BOOL) flag{
    self.root.shouldShowLeftView = flag;
}

#pragma mark - Navigation


-(void)pushViewController:(UIViewController*) controller animated:(BOOL)animated{
    [self.router pushViewController:controller animated:animated];
}

-(void)setViewController:(UIViewController*) controller animated:(BOOL)animated{
    [self.router setViewControllers:@[controller] animated:animated];
}

-(void)presentAsModal:(UIViewController*) controller animated:(BOOL)animated{
    [self.root presentViewController:controller animated:animated completion:nil];
}

-(void)showMenu{
    [self.root showLeftViewAnimated:YES completionHandler:nil];
}
-(void)hideMenuWithCompletesion:(void(^)()) completision{
    [self.root hideLeftViewAnimated:YES completionHandler:completision];
}

#pragma mark - Presenting Controllers

-(void)showSettings{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self setViewController:viewController animated:NO];
    [self hideMenuWithCompletesion:nil];
}

-(void)showWallet{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    [self setViewController:viewController animated:NO];
    [self hideMenuWithCompletesion:nil];
}

-(void)backToSettings{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    self.appDelegate.window.rootViewController = [self congigSideMenuWithFirstController:vc];
    [self shoudShowMenu:YES];
}

#pragma mark - Flows


-(void)startChangePinFlow{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PinViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"PinViewController"];
    ChangePinController* changePinRoot = [[ChangePinController alloc]initWithRootViewController:viewController];
    changePinRoot.changePinCompletesion =  ^(){
        //[self backToSettings];
    };
    viewController.delegate = changePinRoot;
    viewController.type = OldType;
    [self presentAsModal:changePinRoot animated:YES];
}

-(void)startWalletFlow{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"StartViewController"];
    UINavigationController* rootNavigation = [[UINavigationController alloc]initWithRootViewController:viewController];
    rootNavigation.navigationBar.hidden = YES;
    self.appDelegate.window.rootViewController = rootNavigation;
}

-(void)startAskPinFlow:(void(^)()) completesion{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PinViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"PinViewController"];
    AskPinController* askPinRoot = [[AskPinController alloc]initWithRootViewController:viewController];
    askPinRoot.validatePinCompletesion = completesion;
    viewController.delegate = askPinRoot;
    viewController.type = EnterType;
    self.appDelegate.window.rootViewController = askPinRoot;
}

-(void)startMainFlow{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    self.appDelegate.window.rootViewController = [self congigSideMenuWithFirstController:vc];
    [self shoudShowMenu:YES];
}

-(void)startCreatePinFlowWithCompletesion:(void(^)()) completesion{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PinViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"PinViewController"];
    CreatePinRootController* createPinRoot = [[CreatePinRootController alloc]initWithRootViewController:viewController];
    createPinRoot.createPinCompletesion = completesion;
    viewController.delegate = createPinRoot;
    viewController.type = CreateType;
    self.appDelegate.window.rootViewController = createPinRoot;
}
//
//-(void)startImportKeyFlow{
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"ImportKeyViewController"];
//    self.appDelegate.window.rootViewController = createImportRoot;
//}


@end
