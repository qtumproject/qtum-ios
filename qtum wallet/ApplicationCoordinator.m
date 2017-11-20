//
//  ApplicationCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 13.12.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import "TabBarController.h"
#import "LoginCoordinator.h"
#import "TabBarCoordinator.h"
#import "AuthCoordinator.h"
#import "AppDelegate.h"
#import "ConfirmPinCoordinator.h"
#import "ProfileCoordinator.h"
#import "Appearance.h"
#import "SplashScreenOutput.h"
#import "QStoreManager.h"


@interface ApplicationCoordinator () <ApplicationCoordinatorDelegate, SecurityCoordinatorDelegate, LoginCoordinatorDelegate, ConfirmPinCoordinatorDelegate, AuthCoordinatorDelegate>

@property (strong,nonatomic) AppDelegate* appDelegate;
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
        [SLocator.notificationManager registerForRemoutNotifications];
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SLocator.walletManager startObservingForAllSpendable];
        [[ContractManager sharedInstance] startObservingForAllSpendable];
        [[QStoreManager sharedInstance] startObservingForAllRequests];
    });
}

#pragma mark - Public Methods

#pragma mark - Start

-(void)start{

    if (SLocator.walletManager.isSignedIn) {
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

    UINavigationController* navigationController = (UINavigationController*)[SLocator.controllersFactory createAuthNavigationController];
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
    
    [SLocator.walletManager stopObservingForAllSpendable];
    [[ContractManager sharedInstance] stopObservingForAllSpendable];
    [SLocator.notificationManager clear];
    [SLocator.openURLManager clear];
    [SLocator.walletManager clear];
    [[ContractManager sharedInstance] clear];
    [SLocator.templateManager clear];
    [[QStoreManager sharedInstance] clear];
    [SLocator.appSettings clear];
}

- (void)startConfirmPinFlowWithHandler:(void(^)(BOOL)) handler {
    
    if (self.securityCoordinator) {
        [self.securityCoordinator cancelPin];
    } else {
        [[PopUpsManager sharedInstance] hideCurrentPopUp:NO completion:nil];
    }
    
    if (SLocator.walletManager.isSignedIn && !self.authFlowRunning && !self.loginFlowRunning && !self.securityFlowRunning) {
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
    
    UINavigationController* navigationController = (UINavigationController*)[SLocator.controllersFactory createAuthNavigationController];
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
    
    BOOL isDark = [SLocator.appSettings isDarkTheme];
    [SLocator.appSettings changeThemeToDark:!isDark];
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

    UITabBarController <TabbarOutput>* controller = [SLocator.controllersFactory createTabFlow];
    UIViewController* news = [SLocator.controllersFactory newsFlowTab];
    UIViewController* send = [SLocator.controllersFactory sendFlowTab];
    UIViewController* profile = [SLocator.controllersFactory profileFlowTab];
    UIViewController* wallet = [SLocator.controllersFactory walletFlowTab];
    [controller setControllerForNews:news forSend:send forWallet:wallet forProfile:profile];
    TabBarCoordinator* coordinator = [[TabBarCoordinator alloc] initWithTabBarController:controller];
    controller.outputDelegate = coordinator;
    self.tabCoordinator = coordinator;
    [self addDependency:coordinator];
    
    if (self.adress) {
        SendInfoItem *item = [[SendInfoItem alloc] initWithQtumAddress:self.adress tokenAddress:nil amountString:self.amount];
        [coordinator startFromSendWithSendInfoItem:item];
    } else {
        [coordinator start];

    }

    [SLocator.openURLManager storeAuthToYesWithAdddress:SLocator.walletManager.wallet.mainAddress];
}

-(void)restartMainFlow {
    
    if (self.tabCoordinator) {
        [self removeDependency:self.tabCoordinator];
    }
    
    UITabBarController <TabbarOutput>* controller = [SLocator.controllersFactory createTabFlow];
    controller.isReload = YES;
    UIViewController* news = [SLocator.controllersFactory newsFlowTab];
    UIViewController* send = [SLocator.controllersFactory sendFlowTab];
    UIViewController* profile = [SLocator.controllersFactory profileFlowTab];
    UIViewController* wallet = [SLocator.controllersFactory walletFlowTab];
    [controller setControllerForNews:news forSend:send forWallet:wallet forProfile:profile];
    TabBarCoordinator* coordinator = [[TabBarCoordinator alloc] initWithTabBarController:controller];
    self.tabCoordinator = coordinator;
    [self addDependency:coordinator];
    controller.outputDelegate = self.tabCoordinator;
    [coordinator start];
}

- (void)startSplashScreen {
    
    NSObject <SplashScreenOutput> *splash = [SLocator.controllersFactory createSplashScreenOutput];
    self.appDelegate.window.rootViewController = [splash toPresent];
}

#pragma mark - Global Observing

-(void)contractCreationDidFailed {

    NSString *identifire = @"contract_creation_failed";
    [SLocator.notificationManager createLocalNotificationWithString:NSLocalizedString(@"Failed to create contract", @"") andIdentifire:identifire];
}

@end
