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
@property (nonatomic, weak) NSObject <AddressControlOutput> *addressOutput;


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
    //output.addresses = [[ApplicationCoordinator sharedInstance].walletManager.wallet allKeysAdreeses];
    self.addressOutput = output;
    [self.navigationController pushViewController:[output toPresent] animated:YES];
    [self prepareData];
}

-(void)prepareData {
    [[PopUpsManager sharedInstance] showLoaderPopUp];
    
    [[ApplicationCoordinator sharedInstance].requestManager getUnspentOutputsForAdreses:[[ApplicationCoordinator sharedInstance].walletManager.wallet allKeysAdreeses] isAdaptive:YES successHandler:^(id responseObject) {
        
        [[PopUpsManager sharedInstance] dismissLoader];

    } andFailureHandler:^(NSError *error, NSString *message) {
        
        [[PopUpsManager sharedInstance] dismissLoader];
    }];
}

#pragma mark - AddressControlOutputDelegate

-(void)didBackPress {
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.delegate coordinatorLibraryDidEnd:self];
}


@end
