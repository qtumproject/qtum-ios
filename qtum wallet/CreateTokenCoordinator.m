//
//  CreateTokenCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
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
#import "TemplateTokenViewController.h"
#import "ContractFileManager.h"
#import "ChooseSmartContractViewController.h"
#import "SmartContractsListViewController.h"
#import "TokenDetailsViewController.h"
#import "TokenDetailsTableSource.h"
#import "TokenFunctionViewController.h"
#import "TokenFunctionDetailViewController.h"


@interface CreateTokenCoordinator ()

@property (strong, nonatomic) UINavigationController* navigationController;
@property (strong, nonatomic) UINavigationController* modalNavigationController;
@property (strong,nonatomic) NSArray<ResultTokenInputsModel*>* inputs;
@property (strong,nonatomic) TemplateModel* templateModel;
@property (weak, nonatomic) TokenFunctionDetailViewController* functionDetailController;

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
    
    ChooseSmartContractViewController* controller = (ChooseSmartContractViewController*)[[ControllersFactory sharedInstance] createChooseSmartContractViewController];
    controller.delegate = self;
    CreateTokenNavigationController* modal = [[CreateTokenNavigationController alloc] initWithRootViewController:controller];
    self.modalNavigationController = modal;
    [self.navigationController presentViewController:modal animated:YES completion:nil];
}

#pragma mark - Private Methods 

-(void)showCreateNewToken {
    
    TemplateTokenViewController* controller = (TemplateTokenViewController*)[[ControllersFactory sharedInstance] createTemplateTokenViewController];
    controller.delegate = self;
    controller.templateModels = [[ContractFileManager sharedInstance] getAvailebaleTemplates];
    [self.modalNavigationController pushViewController:controller animated:YES];
}

-(void)showMyPyblishedContract {
    
    SmartContractsListViewController* controller = (SmartContractsListViewController*)[[ControllersFactory sharedInstance] createSmartContractsListViewController];
    controller.delegate = self;
    
    NSArray *sortedContracts = [[[TokenManager sharedInstance] getAllContracts] sortedArrayUsingComparator: ^(Contract *t1, Contract *t2) {
        return [t1.creationDate compare:t2.creationDate];
    }];
    controller.contracts = sortedContracts;
    [self.modalNavigationController pushViewController:controller animated:YES];
}

-(void)showContractStore {
    
}

-(void)showStepWithFieldsAndTemplate:(NSString*)template{
    
    CustomAbiInterphaseViewController* controller = (CustomAbiInterphaseViewController*)[[ControllersFactory sharedInstance] createCustomAbiInterphaseViewController];
    controller.delegate = self;
    
    controller.formModel = [[ContractManager sharedInstance] getTokenInterfaceWithTemplate:self.templateModel.templateName];

    [self.modalNavigationController pushViewController:controller animated:YES];
}

-(void)showFinishStepWithInputs:(NSArray<ResultTokenInputsModel*>*) inputs {
    
    CreateTokenFinishViewController* controller = (CreateTokenFinishViewController*)[[ControllersFactory sharedInstance] createCreateTokenFinishViewController];
    controller.delegate = self;
    self.inputs = inputs;
    controller.inputs = inputs;
    [self.modalNavigationController pushViewController:controller animated:YES];
}

-(void)showContractsFunction:(Contract*) contract {
    
    if (contract.templateModel) {
        TokenFunctionViewController* controller = [[ControllersFactory sharedInstance] createTokenFunctionViewController];
        controller.formModel = [[ContractManager sharedInstance] getTokenInterfaceWithTemplate:contract.templateModel.templateName];
        controller.delegate = self;
        controller.token = contract;
        [self.modalNavigationController pushViewController:controller animated:true];
    }
}

#pragma mark - Logic

-(NSArray*)argsFromInputs{
    
    NSMutableArray* args = @[].mutableCopy;
    for (ResultTokenInputsModel* input in self.inputs) {
        [args addObject:input.value];
    }
    return [args copy];
}


#pragma mark - CreateTokenCoordinatorDelegate

-(void)createStepOneCancelDidPressed{
    [self.modalNavigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)createStepOneNextDidPressedWithInputs:(NSArray<ResultTokenInputsModel*>*) inputs {

    [self showFinishStepWithInputs:inputs];
}

-(void)finishStepBackDidPressed {
    
    [self.modalNavigationController popViewControllerAnimated:YES];
}

-(void)finishStepFinishDidPressed{

    __weak __typeof(self)weakSelf = self;
    [SVProgressHUD show];
    
    NSData* contractWithArgs = [[ContractManager sharedInstance] getTokenBitecodeWithTemplate:self.templateModel.templateName andArray:[self argsFromInputs]];
    
    [[TransactionManager sharedInstance] createSmartContractWithKeys:[WalletManager sharedInstance].getCurrentWallet.getAllKeys andBitcode:contractWithArgs andHandler:^(NSError *error, BTCTransaction *transaction, NSString* hashTransaction) {
        if (!error) {
            BTCTransactionInput* input = transaction.inputs[0];
            NSLog(@"%@",input.runTimeAddress);
            [[TokenManager sharedInstance] addSmartContractPretendent:@[input.runTimeAddress] forKey:hashTransaction withTemplate:self.templateModel];
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Done", "")];
        } else {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Failed", "")];
            NSLog(@"Failed Request");
        }
        [weakSelf.modalNavigationController dismissViewControllerAnimated:YES completion:nil];
    }];

    [self.modalNavigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)didDeselectTemplateIndexPath:(NSIndexPath*) indexPath withName:(TemplateModel*) templateModel {
    
    self.templateModel = templateModel;
    [self showStepWithFieldsAndTemplate:templateModel.templateName];
}

-(void)didSelectContractWithIndexPath:(NSIndexPath*) indexPath withContract:(Token*) contract {
    [self showContractsFunction:contract];
}

- (void)didSelectFunctionIndexPath:(NSIndexPath *)indexPath withItem:(AbiinterfaceItem*) item andToken:(Token*) token {
    
    TokenFunctionDetailViewController* controller = [[ControllersFactory sharedInstance] createTokenFunctionDetailViewController];
    controller.function = item;
    controller.delegate = self;
    controller.token = token;
    self.functionDetailController = controller;
    [self.modalNavigationController pushViewController:controller animated:true];
}

- (void)didDeselectFunctionIndexPath:(NSIndexPath *)indexPath withItem:(AbiinterfaceItem*) item{
    
}

- (void)didCallFunctionWithItem:(AbiinterfaceItem*) item
                       andParam:(NSArray<ResultTokenInputsModel*>*)inputs
                       andToken:(Contract*) token {
    
    NSMutableArray* param = @[].mutableCopy;
    for (int i = 0; i < inputs.count; i++) {
        [param addObject:inputs[i].value];
    }
    
    NSData* hashFuction = [[ContractManager sharedInstance] getHashOfFunction:item appendingParam:param];
    
    __weak __typeof(self)weakSelf = self;
    [[TransactionManager sharedInstance] callTokenWithAddress:[NSString dataFromHexString:token.contractAddress] andBitcode:hashFuction fromAddress:token.adresses.firstObject toAddress:nil walletKeys:[WalletManager sharedInstance].getCurrentWallet.getAllKeys andHandler:^(NSError *error, BTCTransaction *transaction, NSString *hashTransaction) {
        
        [weakSelf.functionDetailController showResultViewWithOutputs:nil];
    }];
}



-(void)didSelectContractStore {
    [self showContractStore];
}

-(void)didSelectPublishedContracts {
    [self showMyPyblishedContract];
}

-(void)didSelectNewContracts {
    [self showCreateNewToken];
}

-(void)didPressedQuit {
    
    [self.modalNavigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)didPressedBack {
    
    [self.modalNavigationController popViewControllerAnimated:YES];
}

@end
