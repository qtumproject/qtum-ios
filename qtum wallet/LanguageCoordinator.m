//
//  LanguageCoordinator.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 23.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "LanguageCoordinator.h"
#import "LanguageViewController.h"
#import "LanguageTableSource.h"
#import "ApplicationCoordinator.h"

@interface LanguageCoordinator () <LanguageTableSourceDelegate>

@property (strong, nonatomic) UINavigationController* navigationController;
@property (weak, nonatomic) LanguageViewController* languageViewController;

@end

@implementation LanguageCoordinator

-(instancetype)initWithNavigationController:(UINavigationController*)navigationController{
    self = [super init];
    if (self) {
        _navigationController = navigationController;
    }
    return self;
}

#pragma mark - Coordinatorable

-(void)start{
    [self start:YES];
}

- (void)startWithoutAnimation{
    [self start:NO];
}

- (void)start:(BOOL)animated{
    LanguageViewController* controller = (LanguageViewController*)[[ControllersFactory sharedInstance] createLanguageViewController];
    [self.navigationController pushViewController:controller animated:animated];
    controller.delegate = self;
    LanguageTableSource *tableSource = [LanguageTableSource new];
    tableSource.delegate = self;
    controller.tableSource = tableSource;
    self.languageViewController = controller;
}

#pragma mark - SubscribeTokenCoordinatorDelegate

-(void)didBackButtonPressed{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - LanguageTableSourceDelegate

- (void)languageDidChanged{
    [[ApplicationCoordinator sharedInstance] startChangedLanguageFlow];
}

@end
