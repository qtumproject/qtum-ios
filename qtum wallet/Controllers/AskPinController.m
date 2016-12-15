//
//  AskPinController.m
//  qtum wallet
//
//  Created by Никита Федоренко on 14.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "AskPinController.h"
#import "KeysManager.h"
#import "ApplicationCoordinator.h"

@interface AskPinController ()

@end

@implementation AskPinController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - PinCoordinator

-(void)confirmPin:(NSString*)pin andCompletision:(void(^)(BOOL success)) completision{
    if ([[KeysManager sharedInstance].PIN isEqualToString:pin]) {
        [[ApplicationCoordinator sharedInstance] startMainFlow];
    } else {
        completision(NO);
    }
}

@end
