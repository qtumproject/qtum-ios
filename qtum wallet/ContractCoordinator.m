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
#import "ContractManager.h"
#import "CustomAbiInterphaseViewController.h"
#import "ContractInterfaceManager.h"
#import "CreateTokenFinishViewController.h"
#import "TemplateTokenViewController.h"
#import "ContractFileManager.h"
#import "SmartContractMenuViewController.h"
#import "SmartContractsListViewController.h"
#import "TokenDetailsViewController.h"
#import "TokenDetailsTableSource.h"
#import "TokenFunctionViewController.h"
#import "TokenFunctionDetailViewController.h"
#import "WatchContractViewController.h"
#import "WatchTokensViewController.h"
#import "RestoreContractsViewController.h"
#import "BackupContractsViewController.h"
#import "TemplateManager.h"
#import "QStoreViewController.h"
#import "QStoreListViewController.h"
#import "QStoreContractViewController.h"
#import "Wallet.h"

#import "LibraryOutput.h"
#import "LibraryTableSourceOutput.h"
#import "SmartContractMenuOutput.h"
#import "SmartContractMenuOutputDelegate.h"
#import "TemplatesListOutput.h"
#import "TemplatesListOutputDelegate.h"
#import "FavouriteTemplatesCollectionSourceOutput.h"


@interface ContractCoordinator () <LibraryOutputDelegate,
LibraryTableSourceOutputDelegate,
FavouriteTemplatesCollectionSourceOutputDelegate,
WatchContractOutputDelegate,
SmartContractMenuOutputDelegate,
PublishedContractListOutputDelegate,
TemplatesListOutputDelegate>

@property (strong, nonatomic) UINavigationController* navigationController;
@property (strong, nonatomic) UINavigationController* modalNavigationController;
@property (strong,nonatomic) NSArray<ResultTokenInputsModel*>* inputs;
@property (strong,nonatomic) TemplateModel* templateModel;

@property (weak, nonatomic) TokenFunctionDetailViewController* functionDetailController;
@property (weak, nonatomic) CreateTokenFinishViewController *createFinishViewController;
@property (weak, nonatomic) NSObject <SmartContractMenuOutput>* smartContractMenuOutput;

@property (weak, nonatomic) NSObject <WatchContractOutput> *wathContractsViewController;
@property (nonatomic) NSObject<FavouriteTemplatesCollectionSourceOutput> *favouriteContractsCollectionSource;

@property (weak, nonatomic) NSObject <WatchContractOutput> *wathTokensViewController;
@property (nonatomic) NSObject<FavouriteTemplatesCollectionSourceOutput> *favouriteTokensCollectionSource;

@property (weak, nonatomic) NSObject<LibraryOutput> *libraryViewController;
@property (nonatomic) NSObject<LibraryTableSourceOutput> *libraryTableSource;
@property (nonatomic) TemplateModel *activeTemplateForLibrary;
@property (nonatomic) BOOL isLibraryViewControllerOnlyForTokens;
@property (copy, nonatomic) NSString* localContractName;

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
    
    NSObject <SmartContractMenuOutput>* output = (NSObject <SmartContractMenuOutput>*)[[ControllersFactory sharedInstance] createSmartContractMenuViewController];
    output.delegate = self;
    self.smartContractMenuOutput = output;
    [self.navigationController pushViewController:[output toPresent] animated:YES];
}

#pragma mark - Private Methods 

-(void)showCreateNewToken {
    
    NSObject <TemplatesListOutput>* output  = [[ControllersFactory sharedInstance] createTemplateTokenViewController];
    output.delegate = self;
    output.templateModels = [[TemplateManager sharedInstance] availebaleTemplates];
    [self.navigationController pushViewController:[output toPresent] animated:YES];
}

-(void)showMyPyblishedContract {
    
    NSObject <PublishedContractListOutput>* output = [[ControllersFactory sharedInstance] createSmartContractsListViewController];
    output.delegate = self;
    
    NSArray *sortedContracts = [[[ContractManager sharedInstance] allContracts] sortedArrayUsingComparator: ^(Contract *t1, Contract *t2) {
        return [t1.creationDate compare:t2.creationDate];
    }];
    output.contracts = sortedContracts;
    [self.navigationController pushViewController:[output toPresent] animated:YES];
}

-(void)showContractStore {
    
    QStoreViewController* controller = (QStoreViewController*)[[ControllersFactory sharedInstance] createQStoreViewController];
    controller.delegate = self;
    
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)showQStoreList:(QStoreListType)type categoryTitle:(NSString *)categoryTitle {
    
    QStoreListViewController* controller = (QStoreListViewController*)[[ControllersFactory sharedInstance] createQStoreListViewController];
    controller.delegate = self;
    controller.type = type;
    controller.categoryTitle = categoryTitle;
    
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)showQStoreContract {
    
    QStoreContractViewController* controller = (QStoreContractViewController*)[[ControllersFactory sharedInstance] createQStoreContractViewController];
    controller.delegate = self;
    
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)showWatchContract {
    
    self.activeTemplateForLibrary = nil;
    
    self.wathContractsViewController = (NSObject <WatchContractOutput>*)[[ControllersFactory sharedInstance] createWatchContractViewController];
    self.favouriteContractsCollectionSource = [[TableSourcesFactory sharedInstance] createFavouriteTemplatesSource];
    
    self.favouriteContractsCollectionSource.templateModels = [[TemplateManager sharedInstance] standartPackOfTemplates];
    self.favouriteContractsCollectionSource.delegate = self;
    self.favouriteContractsCollectionSource.activeTemplate = self.activeTemplateForLibrary;
    
    self.wathContractsViewController.collectionSource = self.favouriteContractsCollectionSource;
    self.wathContractsViewController.delegate = self;
    
    [self.navigationController pushViewController:[self.wathContractsViewController toPresent] animated:YES];
}

-(void)showWatchTokens {
    
    self.activeTemplateForLibrary = nil;
    
    self.wathTokensViewController = (NSObject <WatchContractOutput>*)[[ControllersFactory sharedInstance] createWatchTokensViewController];
    self.favouriteTokensCollectionSource = [[TableSourcesFactory sharedInstance] createFavouriteTemplatesSource];
    
    self.favouriteTokensCollectionSource.templateModels = [[TemplateManager sharedInstance] standartPackOfTokenTemplates];
    self.favouriteTokensCollectionSource.delegate = self;
    self.favouriteTokensCollectionSource.activeTemplate = self.activeTemplateForLibrary;
    
    self.wathTokensViewController.collectionSource = self.favouriteTokensCollectionSource;
    self.wathTokensViewController.delegate = self;
    
    [self.navigationController pushViewController:[self.wathTokensViewController toPresent] animated:YES];
}

-(void)showRestoreContract {
    
    RestoreContractsViewController* controller = (RestoreContractsViewController*)[[ControllersFactory sharedInstance] createRestoreContractViewController];
    controller.delegate = self;

    [self.navigationController pushViewController:controller animated:YES];
}

-(void)showBackupContract {
    BackupContractsViewController* controller = (BackupContractsViewController*)[[ControllersFactory sharedInstance] createBackupContractViewController];
    controller.delegate = self;
    
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)showStepWithFieldsAndTemplate:(NSString*)template{
    
    CustomAbiInterphaseViewController* controller = (CustomAbiInterphaseViewController*)[[ControllersFactory sharedInstance] createCustomAbiInterphaseViewController];
    controller.delegate = self;
    controller.contractTitle = self.templateModel.templateName;
    controller.formModel = [[ContractInterfaceManager sharedInstance] tokenInterfaceWithTemplate:self.templateModel.path];
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
        controller.formModel = [[ContractInterfaceManager sharedInstance] tokenInterfaceWithTemplate:contract.templateModel.path];
        controller.delegate = self;
        controller.token = contract;
        [self.navigationController pushViewController:controller animated:true];
    }
}

-(void)showChooseFromLibrary:(BOOL)tokensOnly {
    
    self.isLibraryViewControllerOnlyForTokens = tokensOnly;
    self.libraryViewController = [[ControllersFactory sharedInstance] createLibraryViewController];
    self.libraryTableSource = [[TableSourcesFactory sharedInstance] createLibrarySource];
    self.libraryTableSource.templetes = [self prepareTemplateList:tokensOnly];
    self.libraryTableSource.activeTemplate = self.activeTemplateForLibrary;
    self.libraryTableSource.delegate = self;
    self.libraryViewController.tableSource = self.libraryTableSource;
    self.libraryViewController.delegate = self;
    [self.navigationController pushViewController:[self.libraryViewController toPresent] animated:YES];
}

- (NSArray<TemplateModel *> *)prepareTemplateList:(BOOL)tokensOnly {
    
    return tokensOnly ? [[TemplateManager sharedInstance] availebaleTokenTemplates] : [[TemplateManager sharedInstance] availebaleTemplates];
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

-(void)createStepOneNextDidPressedWithInputs:(NSArray<ResultTokenInputsModel*>*) inputs andContractName:(NSString*) contractName {
    
    self.localContractName = contractName;
    [self showFinishStepWithInputs:inputs];
}

-(void)finishStepBackDidPressed {
    
    [self.navigationController popToViewController:[self.smartContractMenuOutput toPresent] animated:YES];
}

-(void)finishStepFinishDidPressed{

    __weak __typeof(self)weakSelf = self;
    [[PopUpsManager sharedInstance] showLoaderPopUp];
    
    NSData* contractWithArgs = [[ContractInterfaceManager sharedInstance] tokenBitecodeWithTemplate:self.templateModel.path andArray:[self argsFromInputs]];
    
    [[TransactionManager sharedInstance] createSmartContractWithKeys:[ApplicationCoordinator sharedInstance].walletManager.wallet.allKeys andBitcode:contractWithArgs andHandler:^(NSError *error, BTCTransaction *transaction, NSString* hashTransaction) {
        [[PopUpsManager sharedInstance] dismissLoader];
        if (!error) {
            BTCTransactionInput* input = transaction.inputs[0];
            DLog(@"%@",input.runTimeAddress);
            [[ContractManager sharedInstance] addSmartContractPretendent:@[input.runTimeAddress] forKey:hashTransaction withTemplate:weakSelf.templateModel andLocalContractName:self.localContractName];
            
            [weakSelf.createFinishViewController showCompletedPopUp];
        } else {
            if ([error isNoInternetConnectionError]) {
                return;
            }
            [weakSelf.createFinishViewController showErrorPopUp];
        }
    }];
}

- (void)didSelectFunctionIndexPath:(NSIndexPath *)indexPath withItem:(AbiinterfaceItem*) item andToken:(Contract*) token {
    
    [self didSelectFunctionIndexPath:indexPath withItem:item andToken:token fromQStore:NO];
}

- (void)didSelectFunctionIndexPath:(NSIndexPath *)indexPath withItem:(AbiinterfaceItem*) item andToken:(Contract*) token fromQStore:(BOOL)fromQStore {
    
    TokenFunctionDetailViewController* controller = [[ControllersFactory sharedInstance] createTokenFunctionDetailViewController];
    controller.function = item;
    controller.delegate = self;
    controller.token = token;
    controller.fromQStore = fromQStore;
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
    NSData* hashFuction = [[ContractInterfaceManager sharedInstance] hashOfFunction:item appendingParam:param];
    
    __weak __typeof(self)weakSelf = self;
    [[TransactionManager sharedInstance] callTokenWithAddress:[NSString dataFromHexString:token.contractAddress] andBitcode:hashFuction fromAddresses:addressWithTokensValue toAddress:nil walletKeys:[ApplicationCoordinator sharedInstance].walletManager.wallet.allKeys andHandler:^(NSError *error, BTCTransaction *transaction, NSString *hashTransaction) {
        
        [weakSelf.functionDetailController showResultViewWithOutputs:nil];
    }];
}

- (void)didSelectQStoreCategories {
    [self showQStoreList:QStoreCategories categoryTitle:nil];
}

- (void)didSelectQStoreCategory {
    [self showQStoreList:QStoreContracts categoryTitle:@"Some category"];
}

- (void)didSelectQStoreContract {
    [self showQStoreContract];
}

- (void)didSelectQStoreContractDetails {
    [self didSelectFunctionIndexPath:nil withItem:nil andToken:nil fromQStore:YES];
}

-(void)didPressedQuit {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - PublishedContractListOutputDelegate, LibraryOutputDelegate

-(void)didPressedBack {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)didSelectContractWithIndexPath:(NSIndexPath*) indexPath withContract:(Contract*) contract {
    [self showContractsFunction:contract];
}

#pragma mark - TemplatesListOutputDelegate


-(void)didSelectTemplateIndexPath:(NSIndexPath*) indexPath withName:(TemplateModel*) templateModel {
    
    self.templateModel = templateModel;
    [self showStepWithFieldsAndTemplate:templateModel.path];
}


#pragma mark - WatchContractOutputDelegate

- (void)didSelectChooseFromLibrary:(id)sender {
    [self showChooseFromLibrary:[sender isKindOfClass:[WatchTokensViewController class]]];
}

- (void)didChangeAbiText {
    
    self.activeTemplateForLibrary = nil;
    self.favouriteTokensCollectionSource.activeTemplate = self.activeTemplateForLibrary;
    self.favouriteContractsCollectionSource.activeTemplate = self.activeTemplateForLibrary;
}

#pragma mark - SmartContractMenuOutputDelegate

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

- (void)didSelectBackupContract {
    [self showBackupContract];
}

#pragma mark - LibraryOutputDelegate, LibraryTableSourceOutputDelegate, FavouriteTemplatesCollectionSourceOutputDelegate

- (void)didBackPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didSelectTemplate:(TemplateModel *)template sender:(id)sender {
    
    self.activeTemplateForLibrary = template;
    
    if ([sender isEqual:self.libraryTableSource]) {
        if (self.isLibraryViewControllerOnlyForTokens) {
            [self.wathTokensViewController changeStateForSelectedTemplate:template];
        } else {
            [self.wathContractsViewController changeStateForSelectedTemplate:template];
        }
        [self.navigationController popViewControllerAnimated:YES];
        
        self.favouriteTokensCollectionSource.activeTemplate = self.activeTemplateForLibrary;
        self.favouriteContractsCollectionSource.activeTemplate = self.activeTemplateForLibrary;
    }
    if ([sender isEqual:self.favouriteTokensCollectionSource]) {
        [self.wathTokensViewController changeStateForSelectedTemplate:template];
    }
    if ([sender isEqual:self.favouriteContractsCollectionSource]) {
        [self.wathContractsViewController changeStateForSelectedTemplate:template];
    }
}

- (void)didResetToDefaults:(id)sender {
    
    self.activeTemplateForLibrary = nil;

    if ([sender isEqual:self.libraryTableSource]) {
        if (self.isLibraryViewControllerOnlyForTokens) {
            [self.wathTokensViewController changeStateForSelectedTemplate:nil];
        } else {
            [self.wathContractsViewController changeStateForSelectedTemplate:nil];
        }
        
        self.favouriteTokensCollectionSource.activeTemplate = self.activeTemplateForLibrary;
        self.favouriteContractsCollectionSource.activeTemplate = self.activeTemplateForLibrary;
    }
    if ([sender isEqual:self.favouriteTokensCollectionSource]) {
        [self.wathTokensViewController changeStateForSelectedTemplate:nil];
    }
    if ([sender isEqual:self.favouriteContractsCollectionSource]) {
        [self.wathContractsViewController changeStateForSelectedTemplate:nil];
    }
}

@end
