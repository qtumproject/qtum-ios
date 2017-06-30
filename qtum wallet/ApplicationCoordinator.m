//
//  ApplicationCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import "ApplicationCoordinator.h"
#import "CreatePinRootController.h"
#import "PinViewController.h"
#import "SettingsViewController.h"
#import "TabBarController.h"
#import "UIViewController+Extension.h"
#import "ControllersFactory.h"
#import "LoginCoordinator.h"
#import "TabBarCoordinator.h"
#import "RPCRequestManager.h"
#import "LanguageCoordinator.h"
#import "ProfileViewController.h"
#import "TemplateManager.h"
#import "NSUserDefaults+Settings.h"


@interface ApplicationCoordinator ()

@property (strong,nonatomic) AppDelegate* appDelegate;
@property (strong,nonatomic) TabBarController* router;
@property (strong,nonatomic) ControllersFactory* controllersFactory;
@property (strong,nonatomic) UIViewController* viewController;
@property (weak,nonatomic) UINavigationController* navigationController;
@property (weak,nonatomic) TabBarCoordinator* tabCoordinator;
@property (strong,nonatomic) NotificationManager* notificationManager;
@property (weak,nonatomic) LoginCoordinator* loginCoordinator;
@property (weak,nonatomic) SecurityCoordinator* securityCoordinator;
@property (assign, nonatomic) BOOL securityFlowRunning;
@property (assign, nonatomic) BOOL authFlowRunning;
@property (assign, nonatomic) BOOL mainFlowRunning;
@property (assign, nonatomic) BOOL loginFlowRunning;
@property (assign, nonatomic) BOOL confirmFlowRunning;

@property (nonatomic, copy) void (^securityCompletesion)(BOOL success);

@property (nonatomic,strong) NSString *amount;
@property (nonatomic,strong) NSString *adress;

@end

@implementation ApplicationCoordinator

#pragma mark - Initialization

+ (instancetype)sharedInstance {
    
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
        _notificationManager = [NotificationManager new];
        _requestManager = [AppSettings sharedInstance].isRPC ? [RPCRequestManager sharedInstance] : [RequestManager sharedInstance];
    }
    return self;
}

#pragma mark - Public Methods

#pragma mark - Privat Methods

-(AppDelegate*)appDelegate{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

-(void)prepareDataObserving {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.notificationManager registerForRemoutNotifications];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[WalletManager sharedInstance] startObservingForAllSpendable];
        [[ContractManager sharedInstance] startObservingForAllSpendable];
    });
}

#pragma mark - Lazy Getters


#pragma mark - Start

-(void)start{

    if ([[WalletManager sharedInstance] haveWallets] && [WalletManager sharedInstance].PIN) {
        [self startLoginFlow];
    } else {
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

#pragma mark - ConfirmPinCoordinatorDelegate

- (void)coordinatorDidConfirm:(ConfirmPinCoordinator*)coordinator {
    
    self.securityFlowRunning = NO;
    [self removeDependency:coordinator];
}

- (void)coordinatorDidCanceledConfirm:(ConfirmPinCoordinator*)coordinator {
    
    self.securityFlowRunning = NO;
    [self removeDependency:coordinator];
    [[WalletManager sharedInstance] stopObservingForAllSpendable];
    [[ContractManager sharedInstance] stopObservingForAllSpendable];
    [self startAuthFlow];
}

#pragma mark - LoginCoordinatorDelegate

-(void)coordinatorDidLogin:(LoginCoordinator*)coordinator {
    
    self.securityFlowRunning = NO;
    [self removeDependency:coordinator];
    [self startMainFlow];
    [self prepareDataObserving];
}

-(void)coordinatorDidCanceledLogin:(LoginCoordinator*)coordinator {
    
    self.securityFlowRunning = NO;
    [self removeDependency:coordinator];
    [[WalletManager sharedInstance] stopObservingForAllSpendable];
    [[ContractManager sharedInstance] stopObservingForAllSpendable];
    [self startAuthFlow];
}

#pragma mark - SecurityCoordinatorDelegate

- (void)coordinatorDidPassSecurity:(LoginCoordinator*)coordinator {
    
    self.securityFlowRunning = NO;
    [self removeDependency:coordinator];
    if (self.securityCompletesion) {
        self.securityCompletesion(YES);
    }
}

- (void)coordinatorDidCancelePassSecurity:(LoginCoordinator*)coordinator {
    
    self.securityFlowRunning = NO;
    [self removeDependency:coordinator];
    if (self.securityCompletesion) {
        self.securityCompletesion(NO);
    }
}

#pragma mark - AuthCoordinatorDelegate

-(void)coordinatorDidAuth:(AuthCoordinator*)coordinator{
    
    [self removeDependency:coordinator];
    [self startMainFlow];
}

#pragma mark - Presenting Controllers

-(void)showSettings {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self setViewController:viewController animated:NO];
}

-(void)showWallet {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    [self setViewController:viewController animated:NO];
}

-(void)showExportBrainKeyAnimated:(BOOL)animated {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"ExportBrainKeyViewController"];
    [self setViewController:viewController animated:animated];
}

#pragma mark - Flows

-(void)startAuthFlow {
    
    self.authFlowRunning = YES;
    self.mainFlowRunning = NO;
    self.loginFlowRunning = NO;
    self.confirmFlowRunning = NO;

    UINavigationController* navigationController = (UINavigationController*)[[ControllersFactory sharedInstance] createAuthNavigationController];
    self.appDelegate.window.rootViewController = navigationController;
    AuthCoordinator* coordinator = [[AuthCoordinator alloc] initWithNavigationViewController:navigationController];
    coordinator.delegate = self;
    [coordinator start];
    self.navigationController = navigationController;
    [self addDependency:coordinator];
}

-(void)logout {
    
    [self startAuthFlow];
    [self storeAuthorizedFlag:NO andMainAddress:nil];
    [self removeDependency:self.tabCoordinator];
    [[WalletManager sharedInstance] stopObservingForAllSpendable];
    [[ContractManager sharedInstance] stopObservingForAllSpendable];
    [self.notificationManager removeToken];
    [[WalletManager sharedInstance] clear];
    [[ContractManager sharedInstance] clear];
    [[TemplateManager sharedInstance] clear];
}

- (void)startConfirmPinFlowWithHandler:(void(^)(BOOL)) handler {
    
    if (self.securityCoordinator) {
        [self.securityCoordinator cancelPin];
    } else {
        [[PopUpsManager sharedInstance] hideCurrentPopUp:NO completion:nil];
    }
    
    if ([[WalletManager sharedInstance] haveWallets] && [WalletManager sharedInstance].PIN && !self.authFlowRunning && !self.loginFlowRunning && !self.securityFlowRunning) {
        ConfirmPinCoordinator* coordinator = [[ConfirmPinCoordinator alloc] initWithParentViewContainer:self.appDelegate.window.rootViewController];
        coordinator.delegate = self;
        [coordinator start];
        self.securityFlowRunning = YES;
        [self addDependency:coordinator];
    }
}

- (void)startSecurityFlowWithHandler:(void(^)(BOOL)) handler {
    
    SecurityCoordinator* coordinator = [[SecurityCoordinator alloc] initWithParentViewContainer:self.appDelegate.window.rootViewController];
    coordinator.delegate = self;
    [coordinator start];
    self.securityFlowRunning = YES;
    [self addDependency:coordinator];
    self.securityCoordinator = coordinator;
    self.securityCompletesion = handler;
}

- (void)startLoginFlow{
    
    self.loginFlowRunning = YES;
    self.mainFlowRunning = NO;
    self.authFlowRunning = NO;
    self.confirmFlowRunning = NO;
    self.securityFlowRunning = YES;
    
    UINavigationController* navigationController = (UINavigationController*)[[ControllersFactory sharedInstance] createAuthNavigationController];
    self.appDelegate.window.rootViewController = navigationController;
    self.navigationController = navigationController;
    
    LoginCoordinator* coordinator = [[LoginCoordinator alloc] initWithParentViewContainer:self.appDelegate.window.rootViewController];
    coordinator.delegate = self;
    [coordinator start];
    self.loginCoordinator = coordinator;
    [self addDependency:coordinator];
}

-(void)startChangePinFlow{
}

-(void)coordinatorRequestForLogin {
    [self startLoginFlow];
}

-(void)startWalletFlow {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"StartViewController"];
    UINavigationController* rootNavigation = [[UINavigationController alloc]initWithRootViewController:viewController];
    rootNavigation.navigationBar.hidden = YES;
    self.appDelegate.window.rootViewController = rootNavigation;
}

- (void)startChangedLanguageFlow{
    [self restartMainFlow];
    NSInteger profileIndex = 1;
    [self.tabCoordinator showControllerByIndex:profileIndex];
    UINavigationController *vc = (UINavigationController *)[self.tabCoordinator getViewControllerByIndex:profileIndex];
    ProfileViewController *profile = vc.viewControllers[0];
    LanguageCoordinator *languageCoordinator = [[LanguageCoordinator alloc] initWithNavigationController:vc];
    [profile saveLanguageCoordinator:languageCoordinator];
    [languageCoordinator startWithoutAnimation];
}

-(void)startAskPinFlow:(void(^)()) completesion{
}

-(void)startMainFlow {
    
    self.mainFlowRunning = YES;
    self.authFlowRunning = NO;
    self.loginFlowRunning = NO;

    TabBarController* controller = (TabBarController*)[self.controllersFactory createTabFlow];
    TabBarCoordinator* coordinator = [[TabBarCoordinator alloc] initWithTabBarController:controller];
    controller.coordinatorDelegate = coordinator;
    self.tabCoordinator = coordinator;
    [self addDependency:coordinator];
    [coordinator start];
    if (self.adress) {
        [controller selectSendControllerWithAdress:self.adress andValue:self.amount];
    }
    self.router = controller;
    [self storeAuthorizedFlag:YES andMainAddress:[WalletManager sharedInstance].сurrentWallet.mainAddress];
}

-(void)restartMainFlow {
    
    if (self.tabCoordinator) {
        [self removeDependency:self.tabCoordinator];
    }
    TabBarController* controller = (TabBarController*)[self.controllersFactory createTabFlow];
    controller.isReload = YES;
    TabBarCoordinator* coordinator = [[TabBarCoordinator alloc] initWithTabBarController:controller];
    self.tabCoordinator = coordinator;
    [self addDependency:coordinator];
    controller.coordinatorDelegate = self.tabCoordinator;
    [self.tabCoordinator start];
    self.router = controller;
}

-(void)startCreatePinFlowWithCompletesion:(void(^)()) completesion {
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PinViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"PinViewController"];
    CreatePinRootController* createPinRoot = [[CreatePinRootController alloc]initWithRootViewController:viewController];
    createPinRoot.createPinCompletesion = completesion;
    viewController.type = CreateType;
    self.appDelegate.window.rootViewController = createPinRoot;
}


#pragma iMessage Methods

-(void)storeAuthorizedFlag:(BOOL)flag andMainAddress:(NSString *)address {

    [NSUserDefaults saveIsHaveWalletKey:flag ? @"YES" : @"NO" ];
    [NSUserDefaults saveWalletAddressKey:address];
}

-(void)launchFromUrl:(NSURL*)url {
    [self pareceUrl:url];
    [self start];
}

-(void)pareceUrl:(NSURL*)url {

    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url
                                                resolvingAgainstBaseURL:NO];
    NSArray *queryItems = urlComponents.queryItems;
    
    self.adress = [NSString valueForKey:@"adress" fromQueryItems:queryItems];
    self.amount = [NSString valueForKey:@"amount" fromQueryItems:queryItems];
}

@end
