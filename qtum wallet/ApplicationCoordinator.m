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

@implementation ApplicationCoordinator

-(instancetype)initWithAppDelegate:(AppDelegate*) appDelegate{
    self = [super init];
    if (self) {
        self.appDelegate = appDelegate;
    }
    return self;
}

-(void)start{
    [Appearance setUp];

    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NSString *rootVCkey;
    if ([KeysManager sharedInstance].keys.count != 0) {
        rootVCkey = @"MainViewController";
    }else{
        rootVCkey = @"StartViewController";
    }
    UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:rootVCkey];
    self.appDelegate.window.rootViewController = vc;
}

@end
