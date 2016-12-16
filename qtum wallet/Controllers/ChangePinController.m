//
//  ChangePinController.m
//  qtum wallet
//
//  Created by Никита Федоренко on 16.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "ChangePinController.h"
#import "ApplicationCoordinator.h"
#import "KeysManager.h"

@interface ChangePinController ()

@property (strong,nonatomic) NSString* pinNew;
@property (strong,nonatomic) NSString* pinOld;

@end

@implementation ChangePinController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark PinCoordinator

-(void)confirmPin:(NSString*)pin andCompletision:(void(^)(BOOL success)) completision{
    if (!self.pinOld) {
        if ([[KeysManager sharedInstance].PIN isEqualToString:pin]) {
            self.pinOld = pin;
            [self showNewPinControllerWithType:NewType];
        }else {
            completision(NO);
        }
    } else if(!self.pinNew) {
        self.pinNew = pin;
        [self showNewPinControllerWithType:NewType];
    } else {
        if (self.pinNew == pin) {
            [[KeysManager sharedInstance] storePin:self.pinNew];
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        } else {
            self.pinOld = nil;
            self.pinNew = nil;
            [self showNewPinControllerWithType:OldType];
        }
    }
}

-(void)setAnimationState:(BOOL)isAnimating{
    NSLog(@"stop animating");
    self.animating = isAnimating;
}

#pragma mark - Private Methods

-(void)confilmPinFailed{
    [self showNewPinControllerWithType:ConfirmType];
}

-(void)showNewPinControllerWithType:(PinType) type{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PinViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"PinViewController"];
    viewController.delegate = self;
    viewController.type = type;
    if (!self.animating) {
        self.animating = YES;
        [self setViewControllers:@[viewController] animated:NO];
        NSLog(@"start animating");
    }
}


@end
