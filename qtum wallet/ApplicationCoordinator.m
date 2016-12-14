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

    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NSString *rootVCkey;
    BOOL needSecurController = true;
    if ([KeysManager sharedInstance].keys.count && [KeysManager sharedInstance].PIN) {
        rootVCkey = @"MainViewController";
        needSecurController = true;
    }else{
        rootVCkey = @"StartViewController";
    }
    
    UIViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:rootVCkey];
    self.appDelegate.window.rootViewController = [self congigSideMenuWithFirstController:viewController];
    [self shoudShowMenu:NO];
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

-(void)pushViewController:(UIViewController*) controller animated:(BOOL)animated{
    [self.router pushViewController:controller animated:animated];
}

-(void)setViewController:(UIViewController*) controller animated:(BOOL)animated{
    [self.router setViewControllers:@[controller] animated:animated];
}

-(void)presentAsModal:(UIViewController*) controller animated:(BOOL)animated{
    [self.root presentViewController:controller animated:animated completion:nil];
}

@end
