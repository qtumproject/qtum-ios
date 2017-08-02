//
//  AddressLibruaryCoordinator.m
//  qtum wallet
//
//  Created by Никита Федоренко on 02.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "AddressLibruaryCoordinator.h"
#import "AddressControlOutput.h"
#import "Wallet.h"

@interface AddressLibruaryCoordinator () <AddressControlOutputDelegate>

@property (nonatomic, strong) UINavigationController *navigationController;

@end

@implementation AddressLibruaryCoordinator

-(instancetype)initWithNavigationViewController:(UINavigationController*)navigationController {
    
    self = [super init];
    if (self) {
        _navigationController = navigationController;
    }
    return self;
}

-(void)start {
    
    NSObject <AddressControlOutput> *output = [[ControllersFactory sharedInstance] createAddressControllOutput];
    output.delegate = self;
    output.addresses = [[ApplicationCoordinator sharedInstance].walletManager.wallet allKeys];
    [self.navigationController pushViewController:[output toPresent] animated:YES];
}

#pragma mark - AddressControlOutputDelegate

-(void)didBackPress {
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
