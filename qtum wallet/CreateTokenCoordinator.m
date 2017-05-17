//
//  CreateTokenCoordinator.m
//  qtum wallet
//
//  Created by Никита Федоренко on 03.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import "CreateTokenCoordinator.h"
#import "CreateTokenNavigationController.h"
#import "TransactionManager.h"
#import "NSString+Extension.h"
#import "BTCTransactionInput+Extension.h"
#import "TokenManager.h"
#import "CustomAbiInterphaseViewController.h"
#import "ContractManager.h"
#import "CreateTokenFinishViewController.h"


@interface CreateTokenCoordinator ()

@property (strong, nonatomic) UINavigationController* navigationController;
@property (strong, nonatomic) UINavigationController* modalNavigationController;

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

-(void)start {
    
    CustomAbiInterphaseViewController* controller = (CustomAbiInterphaseViewController*)[[ControllersFactory sharedInstance] createCustomAbiInterphaseViewController];
    controller.delegate = self;
    
    controller.formModel = [[ContractManager sharedInstance] getStandartTokenIntephase];
    CreateTokenNavigationController* modal = [[CreateTokenNavigationController alloc] initWithRootViewController:controller];
    self.modalNavigationController = modal;
    [self.navigationController presentViewController:modal animated:YES completion:nil];
}

#pragma mark - Private Methods 

-(void)showFinishStepWithInputs:(NSArray<ResultTokenCreateInputModel*>*) inputs{
    CreateTokenFinishViewController* controller = (CreateTokenFinishViewController*)[[ControllersFactory sharedInstance] createCreateTokenFinishViewController];
    controller.delegate = self;
    controller.inputs = inputs;
    [self.modalNavigationController pushViewController:controller animated:YES];
}


#pragma mark - CreateTokenCoordinatorDelegate

-(void)createStepOneCancelDidPressed{
    [self.modalNavigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)createStepOneNextDidPressedWithInputs:(NSArray<ResultTokenCreateInputModel*>*) inputs {

    [self showFinishStepWithInputs:inputs];
}

-(void)finishStepBackDidPressed{
    [self.modalNavigationController popViewControllerAnimated:YES];
}

-(void)finishStepFinishDidPressed{
    /*
//    {
//        "initialSupply": uint256,
//        "tokenName": String
//        "decimalUnits": uint8
//        "tokenSymbol": String
//    }
    __weak __typeof(self)weakSelf = self;
    [SVProgressHUD show];
    [[ApplicationCoordinator sharedInstance].requestManager generateTokenBitcodeWithDict:@{@"initialSupply" : self.tokenSupply,
                                                                                  @"tokenName" : self.tokenName,
                                                                                  @"decimalUnits" : self.tokenUnits,
                                                                                  @"tokenSymbol" : self.tokenSymbol
                                                                                  }
                                                             withSuccessHandler:^(id responseObject)
    {
        NSLog(@"  -->  %@",responseObject);
         [[TransactionManager sharedInstance] createSmartContractWithKeys:[WalletManager sharedInstance].getCurrentWallet.getAllKeys andBitcode:[NSString dataFromHexString:responseObject[@"bytecode"]] andHandler:^(NSError *error, BTCTransaction *transaction, NSString* hashTransaction) {
             if (!error) {
                 BTCTransactionInput* input = transaction.inputs[0];
                 NSLog(@"%@",input.runTimeAddress);
                 [[TokenManager sharedInstance] addSmartContractPretendent:@[input.runTimeAddress] forKey:hashTransaction];
                 [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Done", "")];
             } else {
                 [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Failed", "")];
                 NSLog(@"Failed Request");
             }
             [weakSelf.modalNavigationController dismissViewControllerAnimated:YES completion:nil];

         }];
//         TransactionManager *transactionManager = [[TransactionManager alloc] initWith:array];
//                                                                 [transactionManager sendSmartTransaction:[NSString dataFromHexString:responseObject[@"bytecode"]] withSuccess:^(NSData* address){
//                                                                     NSLog(@"Succes");
//                                                                 } andFailure:^(NSString *message) {
//                                                                     NSLog(@"Failed");
//                                                                 }];

    } andFailureHandler:^(NSError *error, NSString *message) {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Failed", "")];
        [self.modalNavigationController dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"Failed Request");
    }];
     */
    [self.modalNavigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
