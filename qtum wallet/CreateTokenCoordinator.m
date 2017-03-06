//
//  CreateTokenCoordinator.m
//  qtum wallet
//
//  Created by Никита Федоренко on 03.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "CreateTokenCoordinator.h"
#import "CreateTokenStep1ViewController.h"
#import "CreateTokenStep2ViewController.h"
#import "CreateTokenStep3ViewController.h"
#import "CreateTokenStep4ViewController.h"
#import "CreateTokenNavigationController.h"


@interface CreateTokenCoordinator ()

@property (strong, nonatomic) UINavigationController* navigationController;
@property (strong, nonatomic) UINavigationController* modalNavigationController;

@property (strong, nonatomic) NSString* tokenName;
@property (strong, nonatomic) NSString* tokenSymbol;
@property (strong, nonatomic) NSString* tokenSupply;
@property (strong, nonatomic) NSString* tokenUnits;

@property (assign, nonatomic)BOOL freazingOfAssets;
@property (assign, nonatomic)BOOL autoScrollingAndBuing;
@property (assign, nonatomic)BOOL autorefill;
@property (assign, nonatomic)BOOL proofOfWork;



@end

@implementation CreateTokenCoordinator

-(instancetype)initWithNavigationController:(UINavigationController*)navigationController{
    self = [super init];
    if (self) {
        _navigationController = navigationController;
    }
    return self;
}

#pragma mark - Coordinatorable

-(void)start{
    CreateTokenStep1ViewController* controller = (CreateTokenStep1ViewController*)[[ControllersFactory sharedInstance] createCreateTokenStep1ViewController];
    controller.delegate = self;
    CreateTokenNavigationController* modal = [[CreateTokenNavigationController alloc] initWithRootViewController:controller];
    self.modalNavigationController = modal;
    [self.navigationController presentViewController:modal animated:YES completion:nil];
}

#pragma mark - Private Methods 

-(void)showStep2{
    CreateTokenStep2ViewController* controller = (CreateTokenStep2ViewController*)[[ControllersFactory sharedInstance] createCreateTokenStep2ViewController];
    controller.delegate = self;
    [self.modalNavigationController pushViewController:controller animated:YES];
}

-(void)showStep3{
    CreateTokenStep3ViewController* controller = (CreateTokenStep3ViewController*)[[ControllersFactory sharedInstance] createCreateTokenStep3ViewController];
    controller.delegate = self;
    [self.modalNavigationController pushViewController:controller animated:YES];
}

-(void)showStep4{
    CreateTokenStep4ViewController* controller = (CreateTokenStep4ViewController*)[[ControllersFactory sharedInstance] createCreateTokenStep4ViewController];
    controller.delegate = self;
    controller.tokenName = self.tokenName;
    controller.tokenSymbol = self.tokenSymbol;
    controller.freezingOfAssets = self.freazingOfAssets ? @"YES" : @"NO";
    controller.autorefill = self.autorefill ? @"YES" : @"NO";
    controller.automaticSellingAndBuing = self.autoScrollingAndBuing ? @"YES" : @"NO";
    controller.proofOfWork = self.proofOfWork ? @"YES" : @"NO";
    controller.decimalNumber = self.tokenUnits;
    controller.initialSupply = self.tokenSupply;
    [self.modalNavigationController pushViewController:controller animated:YES];
}

#pragma mark - CreateTokenCoordinatorDelegate

-(void)createStepOneCancelDidPressed{
    [self.modalNavigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)createStepOneNextDidPressedWithName:(NSString*) name andSymbol:(NSString*)symbol{
    self.tokenName = name;
    self.tokenSymbol = symbol;
    [self showStep2];
}

-(void)createStepTwoBackDidPressed{
    [self.modalNavigationController popViewControllerAnimated:YES];
}

-(void)createStepTwoNextDidPressedWithParam:(NSDictionary*)param{
//    @{@"freazingOfAssets" : @(self.freazingOfAssets),
//      @"autoScrollingAndBuing" : @(self.autoScrollingAndBuing),
//      @"autorefill" : @(self.Autorefill),
//      @"proofOfWork" : @(self.proofOfWork)
//      };
    self.freazingOfAssets = [param[@"freazingOfAssets"] boolValue];
    self.autoScrollingAndBuing = [param[@"autoScrollingAndBuing"] boolValue];
    self.autorefill = [param[@"autorefill"] boolValue];
    self.proofOfWork = [param[@"proofOfWork"] boolValue];

    [self showStep3];
}

-(void)createStepThreeBackDidPressed{
    [self.modalNavigationController popViewControllerAnimated:YES];
}

-(void)createStepThreeNextDidPressedWithSupply:(NSString*) supply andUnits:(NSString*)units{
    self.tokenSupply = supply;
    self.tokenUnits = units;
    [self showStep4];
}

-(void)createStepFourBackDidPressed{
    [self.modalNavigationController popViewControllerAnimated:YES];
}

-(void)createStepFourFinishDidPressed{
    [self.modalNavigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
