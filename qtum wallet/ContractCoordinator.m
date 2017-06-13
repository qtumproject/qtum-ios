//
//  ContractCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "ContractCoordinator.h"
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
#import "WatchContractViewController.h"
#import "WatchTokensViewController.h"
#import "RestoreContractsViewController.h"


@interface ContractCoordinator ()

@property (strong, nonatomic) UINavigationController* navigationController;
@property (strong, nonatomic) UINavigationController* modalNavigationController;
@property (strong,nonatomic) NSArray<ResultTokenInputsModel*>* inputs;
@property (strong,nonatomic) TemplateModel* templateModel;

@property (weak, nonatomic) TokenFunctionDetailViewController* functionDetailController;
@property (weak, nonatomic) CreateTokenFinishViewController *createFinishViewController;
@property (weak, nonatomic) ChooseSmartContractViewController *chooseSmartContractViewController;

@end

@implementation ContractCoordinator

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
    self.chooseSmartContractViewController = controller;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Private Methods 

-(void)showCreateNewToken {
    
    TemplateTokenViewController* controller = (TemplateTokenViewController*)[[ControllersFactory sharedInstance] createTemplateTokenViewController];
    controller.delegate = self;
    controller.templateModels = [[ContractFileManager sharedInstance] getAvailebaleTemplates];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)showMyPyblishedContract {
    
    SmartContractsListViewController* controller = (SmartContractsListViewController*)[[ControllersFactory sharedInstance] createSmartContractsListViewController];
    controller.delegate = self;
    
    NSArray *sortedContracts = [[[TokenManager sharedInstance] getAllContracts] sortedArrayUsingComparator: ^(Contract *t1, Contract *t2) {
        return [t1.creationDate compare:t2.creationDate];
    }];
    controller.contracts = sortedContracts;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)showContractStore {
    
}

-(void)showWatchContract {
    WatchContractViewController* controller = (WatchContractViewController*)[[ControllersFactory sharedInstance] createWatchContractViewController];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)showWatchTokens {
    WatchTokensViewController* controller = (WatchTokensViewController*)[[ControllersFactory sharedInstance] createWatchTokensViewController];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)showRestoreContract {
    RestoreContractsViewController* controller = (RestoreContractsViewController*)[[ControllersFactory sharedInstance] createRestoreContractViewController];
    controller.delegate = self;

    [self.navigationController pushViewController:controller animated:YES];
}

-(void)showStepWithFieldsAndTemplate:(NSString*)template{
    
    CustomAbiInterphaseViewController* controller = (CustomAbiInterphaseViewController*)[[ControllersFactory sharedInstance] createCustomAbiInterphaseViewController];
    controller.delegate = self;
    
    controller.formModel = [[ContractManager sharedInstance] getTokenInterfaceWithTemplate:self.templateModel.templateName];

    [self.navigationController pushViewController:controller animated:YES];
}

-(void)showFinishStepWithInputs:(NSArray<ResultTokenInputsModel*>*) inputs {
    
    CreateTokenFinishViewController* controller = (CreateTokenFinishViewController*)[[ControllersFactory sharedInstance] createCreateTokenFinishViewController];
    controller.delegate = self;
    self.inputs = inputs;
    controller.inputs = inputs;
    self.createFinishViewController = controller;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)showContractsFunction:(Contract*) contract {
    
    if (contract.templateModel) {
        TokenFunctionViewController* controller = [[ControllersFactory sharedInstance] createTokenFunctionViewController];
        controller.formModel = [[ContractManager sharedInstance] getTokenInterfaceWithTemplate:contract.templateModel.templateName];
        controller.delegate = self;
        controller.token = contract;
        [self.navigationController pushViewController:controller animated:true];
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


#pragma mark - ContractCoordinatorDelegate

-(void)createStepOneCancelDidPressed{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)createStepOneNextDidPressedWithInputs:(NSArray<ResultTokenInputsModel*>*) inputs {

    [self showFinishStepWithInputs:inputs];
}

-(void)finishStepBackDidPressed {
    
    [self.navigationController popToViewController:self.chooseSmartContractViewController animated:YES];
}

-(void)finishStepFinishDidPressed{

    __weak __typeof(self)weakSelf = self;
    [[PopUpsManager sharedInstance] showLoaderPopUp];
    
    NSData* contractWithArgs = [[ContractManager sharedInstance] getTokenBitecodeWithTemplate:self.templateModel.templateName andArray:[self argsFromInputs]];
    
    [[TransactionManager sharedInstance] createSmartContractWithKeys:[WalletManager sharedInstance].getCurrentWallet.getAllKeys andBitcode:contractWithArgs andHandler:^(NSError *error, BTCTransaction *transaction, NSString* hashTransaction) {
        [[PopUpsManager sharedInstance] dismissLoader];
        if (!error) {
            BTCTransactionInput* input = transaction.inputs[0];
            NSLog(@"%@",input.runTimeAddress);
            [[TokenManager sharedInstance] addSmartContractPretendent:@[input.runTimeAddress] forKey:hashTransaction withTemplate:weakSelf.templateModel];
            
            [weakSelf.createFinishViewController showCompletedPopUp];
        } else {
            if ([error isNoInternetConnectionError]) {
                return;
            }
            [weakSelf.createFinishViewController showErrorPopUp];
        }
    }];
}

-(void)didDeselectTemplateIndexPath:(NSIndexPath*) indexPath withName:(TemplateModel*) templateModel {
    
    self.templateModel = templateModel;
    [self showStepWithFieldsAndTemplate:templateModel.templateName];
}

-(void)didSelectContractWithIndexPath:(NSIndexPath*) indexPath withContract:(Contract*) contract {
    [self showContractsFunction:contract];
}

- (void)didSelectFunctionIndexPath:(NSIndexPath *)indexPath withItem:(AbiinterfaceItem*) item andToken:(Contract*) token {
    
    TokenFunctionDetailViewController* controller = [[ControllersFactory sharedInstance] createTokenFunctionDetailViewController];
    controller.function = item;
    controller.delegate = self;
    controller.token = token;
    self.functionDetailController = controller;
    [self.navigationController pushViewController:controller animated:true];
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
    
    NSMutableArray<NSString*>* __block addressWithTokensValue = @[].mutableCopy;
    [token.addressBalanceDictionary enumerateKeysAndObjectsUsingBlock:^(NSString* address, NSNumber* balance, BOOL * _Nonnull stop) {
        if (balance.floatValue > 0) {
            [addressWithTokensValue addObject:address];
        }
    }];
    NSData* hashFuction = [[ContractManager sharedInstance] getHashOfFunction:item appendingParam:param];
    
    __weak __typeof(self)weakSelf = self;
    [[TransactionManager sharedInstance] callTokenWithAddress:[NSString dataFromHexString:token.contractAddress] andBitcode:hashFuction fromAddresses:addressWithTokensValue toAddress:nil walletKeys:[WalletManager sharedInstance].getCurrentWallet.getAllKeys andHandler:^(NSError *error, BTCTransaction *transaction, NSString *hashTransaction) {
        
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

-(void)didSelectWatchContracts {
    [self showWatchContract];
}

-(void)didSelectWatchTokens {
    [self showWatchTokens];
}

- (void)didSelectRestoreContract {
    [self showRestoreContract];
}

-(void)didPressedQuit {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)didPressedBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
