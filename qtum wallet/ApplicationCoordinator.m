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
#import "TabBarController.h"
#import "UIViewController+Extension.h"
#import "ControllersFactory.h"
#import "LoginCoordinator.h"
#import "TabBarCoordinator.h"
#import "RPCRequestManager.h"
#import "TemplateManager.h"
#import "NSUserDefaults+Settings.h"
#import "NotificationManager.h"
#import "AuthCoordinator.h"
#import "LoginCoordinator.h"
#import "SecurityCoordinator.h"
#import "AppDelegate.h"
#import "ConfirmPinCoordinator.h"
#import "OpenURLManager.h"
#import "ProfileCoordinator.h"
#import "WalletManager.h"
#import "Wallet.h"
#import "Appearance.h"
#import "SplashScreenOutput.h"
#import "QStoreManager.h"

@interface ApplicationCoordinator () <ApplicationCoordinatorDelegate, SecurityCoordinatorDelegate, LoginCoordinatorDelegate, ConfirmPinCoordinatorDelegate, AuthCoordinatorDelegate>

@property (strong,nonatomic) AppDelegate* appDelegate;
@property (strong,nonatomic) NotificationManager* notificationManager;
@property (strong,nonatomic) ControllersFactory* controllersFactory;

@property (weak,nonatomic) TabBarCoordinator* tabCoordinator;
@property (weak,nonatomic) LoginCoordinator* loginCoordinator;
@property (weak,nonatomic) SecurityCoordinator* securityCoordinator;

@property (strong,nonatomic) UIViewController* viewController;
@property (weak,nonatomic) UINavigationController* navigationController;

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
        _openUrlManager = [OpenURLManager new];
        _requestManager = [AppSettings sharedInstance].isRPC ? [RPCRequestManager sharedInstance] : [RequestManager sharedInstance];
        _walletManager = [WalletManager new];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contractCreationDidFailed) name:kContractCreationFailed object:nil];
    }
    return self;
}

#pragma mark - Lazy Getters

-(AppDelegate*)appDelegate {
    
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

#pragma mark - Privat Methods

-(void)prepareDataObserving {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.notificationManager registerForRemoutNotifications];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.walletManager startObservingForAllSpendable];
        [[ContractManager sharedInstance] startObservingForAllSpendable];
        [[QStoreManager sharedInstance] startObservingForAllRequests];
    });
}

#pragma mark - Public Methods

#pragma mark - Start

-(void)start{

    if (self.walletManager.isSignedIn) {
        [self startLoginFlow];
    } else {
        [self startAuthFlow];
    }
}

#pragma mark - ConfirmPinCoordinatorDelegate

- (void)coordinatorDidConfirm:(ConfirmPinCoordinator*)coordinator {
    
    self.securityFlowRunning = NO;
    [self removeDependency:coordinator];
}

- (void)coordinatorDidCanceledConfirm:(ConfirmPinCoordinator*)coordinator {
    
    self.securityFlowRunning = NO;
    [self removeDependency:coordinator];
    //[self.walletManager stopObservingForAllSpendable];
   //[[ContractManager sharedInstance] stopObservingForAllSpendable];
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
//    [self.walletManager stopObservingForAllSpendable];
//    [[ContractManager sharedInstance] stopObservingForAllSpendable];
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
    [self prepareDataObserving];
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
    [self removeDependency:self.tabCoordinator];
    [self clear];
}

-(void)clear {
    
    [self.walletManager stopObservingForAllSpendable];
    [[ContractManager sharedInstance] stopObservingForAllSpendable];
    [self.notificationManager clear];
    [self.openUrlManager clear];
    [self.walletManager clear];
    [[ContractManager sharedInstance] clear];
    [[TemplateManager sharedInstance] clear];
    [[QStoreManager sharedInstance] clear];
}

- (void)startConfirmPinFlowWithHandler:(void(^)(BOOL)) handler {
    
    if (self.securityCoordinator) {
        [self.securityCoordinator cancelPin];
    } else {
        [[PopUpsManager sharedInstance] hideCurrentPopUp:NO completion:nil];
    }
    
    if (self.walletManager.isSignedIn && !self.authFlowRunning && !self.loginFlowRunning && !self.securityFlowRunning) {
        ConfirmPinCoordinator* coordinator = [[ConfirmPinCoordinator alloc] initWithParentViewContainer:self.appDelegate.window.rootViewController];
        coordinator.delegate = self;
        [coordinator start];
        self.securityFlowRunning = YES;
        [self addDependency:coordinator];
    }
}

- (void)startSecurityFlowWithType:(SecurityCheckingType) type WithHandler:(void(^)(BOOL)) handler {
    
    SecurityCoordinator* coordinator = [[SecurityCoordinator alloc] initWithParentViewContainer:self.appDelegate.window.rootViewController];
    coordinator.delegate = self;
    coordinator.type = type;
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

-(void)coordinatorRequestForLogin {
    [self startLoginFlow];
}

- (void)startChangedLanguageFlow {
    
    [self restartMainFlow];
    NSInteger profileIndex = 1;
    [self.tabCoordinator showControllerByIndex:profileIndex];
    UINavigationController *vc = (UINavigationController *)[self.tabCoordinator getViewControllerByIndex:profileIndex];
    
    ProfileCoordinator *coordinator = [[ProfileCoordinator alloc] initWithNavigationController:vc];
    [self.tabCoordinator addDependency:coordinator];
    [coordinator startFromLanguage];
}

-(void)startChanginTheme {
    
    BOOL isDark = [[AppSettings sharedInstance] isDarkTheme];
    [[AppSettings sharedInstance] changeThemeToDark:!isDark];
    [Appearance setUp];
    [self restartMainFlow];
    NSInteger profileIndex = 1;
    [self.tabCoordinator showControllerByIndex:profileIndex];
    UINavigationController *vc = (UINavigationController *)[self.tabCoordinator getViewControllerByIndex:profileIndex];
    
    ProfileCoordinator *coordinator = [[ProfileCoordinator alloc] initWithNavigationController:vc];
    [self.tabCoordinator addDependency:coordinator];
    [coordinator start];
}

- (void)startFromOpenURLWithAddress:(NSString*) address andAmount:(NSString*) amount {
    
    self.adress = address;
    self.amount = amount;
    [self start];
}

-(void)startMainFlow {
    
    self.mainFlowRunning = YES;
    self.authFlowRunning = NO;
    self.loginFlowRunning = NO;

    UITabBarController <TabbarOutput>* controller = [self.controllersFactory createTabFlow];
    UIViewController* news = [[ControllersFactory sharedInstance] newsFlowTab];
    UIViewController* send = [[ControllersFactory sharedInstance] sendFlowTab];
    UIViewController* profile = [[ControllersFactory sharedInstance] profileFlowTab];
    UIViewController* wallet = [[ControllersFactory sharedInstance] walletFlowTab];
    [controller setControllerForNews:news forSend:send forWallet:wallet forProfile:profile];
    TabBarCoordinator* coordinator = [[TabBarCoordinator alloc] initWithTabBarController:controller];
    controller.outputDelegate = coordinator;
    self.tabCoordinator = coordinator;
    [self addDependency:coordinator];
    
    if (self.adress) {
        QRCodeItem *item = [[QRCodeItem alloc] initWithQtumAddress:self.adress tokenAddress:nil amountString:self.amount];
        [coordinator startFromSendWithQRCodeItem:item];
    } else {
        [coordinator start];

    }

    [self.openUrlManager storeAuthToYesWithAdddress:self.walletManager.wallet.mainAddress];
}

-(void)restartMainFlow {
    
    if (self.tabCoordinator) {
        [self removeDependency:self.tabCoordinator];
    }
    
    UITabBarController <TabbarOutput>* controller = [self.controllersFactory createTabFlow];
    controller.isReload = YES;
    UIViewController* news = [[ControllersFactory sharedInstance] newsFlowTab];
    UIViewController* send = [[ControllersFactory sharedInstance] sendFlowTab];
    UIViewController* profile = [[ControllersFactory sharedInstance] profileFlowTab];
    UIViewController* wallet = [[ControllersFactory sharedInstance] walletFlowTab];
    [controller setControllerForNews:news forSend:send forWallet:wallet forProfile:profile];
    TabBarCoordinator* coordinator = [[TabBarCoordinator alloc] initWithTabBarController:controller];
    self.tabCoordinator = coordinator;
    [self addDependency:coordinator];
    controller.outputDelegate = self.tabCoordinator;
    [coordinator start];
}

- (void)startSplashScreen {
    
    NSObject <SplashScreenOutput> *splash = [[ControllersFactory sharedInstance] createSplashScreenOutput];
    self.appDelegate.window.rootViewController = [splash toPresent];
}

#pragma mark - Global Observing

-(void)contractCreationDidFailed {
    
    [[ApplicationCoordinator sharedInstance].notificationManager createLocalNotificationWithString:NSLocalizedString(@"Failed to create contract", @"") andIdentifire:@"contract_creation_failed"];
}

@end
