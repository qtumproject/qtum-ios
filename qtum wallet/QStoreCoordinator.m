//
//  QStoreCoordinator.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreCoordinator.h"
#import "QStoreMainOutput.h"
#import "ContractFunctionDetailOutput.h"

#import "QStoreListViewController.h"

#import "QStoreManager.h"
#import "QStoreContractOutput.h"

@interface QStoreCoordinator() <QStoreMainOutputDelegate, QStoreContractOutputDelegate, ContractFunctionDetailOutputDelegate>

@property (strong, nonatomic) UINavigationController* navigationController;

@property (strong, nonatomic) NSObject<QStoreMainOutput> *mainScreen;
@property (strong, nonatomic) NSObject<QStoreContractOutput> *contractScreen;
@property (strong, nonatomic) NSObject<ContractFunctionDetailOutput> *functionDetailController;

@end

@implementation QStoreCoordinator

- (instancetype)initWithNavigationController:(UINavigationController*)navigationController {
    self = [super init];
    if (self) {
        _navigationController = navigationController;
    }
    return self;
}

#pragma mark - Coordinatorable

- (void)start {
    NSObject<QStoreMainOutput> *mainScreen = (NSObject<QStoreMainOutput> *)[[ControllersFactory sharedInstance] createQStoreMainViewController];
    mainScreen.delegate = self;
    self.mainScreen = mainScreen;
    [self.navigationController pushViewController:[mainScreen toPresent] animated:YES];
}

#pragma mark - For all delegates

- (void)didPressedBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - QStoreMainOutputDelegate

- (void)didSelectQStoreCategories {
    [self showQStoreList:QStoreCategories categoryTitle:nil];
}

- (void)didSelectQStoreCategory {
    [self showQStoreList:QStoreContracts categoryTitle:@"Some category"];
}

- (void)didSelectQStoreShortContractElement:(QStoreShortContractElement *)element {
    NSObject<QStoreContractOutput> *controller = (NSObject<QStoreContractOutput> *)[[ControllersFactory sharedInstance] createQStoreContractViewController];
    self.contractScreen = controller;
    
    [controller setShortContract:element];
    controller.delegate = self;
    
    [self.navigationController pushViewController:[controller toPresent] animated:YES];
}

- (void)didSelectQStoreContractDetails {
    [self didSelectFunctionIndexPath:nil withItem:nil andToken:nil fromQStore:YES];
}

- (void)didLoadTrendingNow {
    [self.mainScreen startLoading];
    __weak typeof(self) weakSelt = self;
    [[QStoreManager sharedInstance] loadContractsForCategoriesWithSuccessHandler:^(NSArray<QStoreCategory *> *categories) {
        [weakSelt.mainScreen stopLoading];
        [weakSelt.mainScreen setCategories:categories];
    } andFailureHandler:^(NSString *message) {
        [weakSelt.mainScreen stopLoading];
    }];
}

-(void)showQStoreList:(QStoreListType)type categoryTitle:(NSString *)categoryTitle {
    QStoreListViewController* controller = (QStoreListViewController*)[[ControllersFactory sharedInstance] createQStoreListViewController];
    controller.delegate = self;
    controller.type = type;
    controller.categoryTitle = categoryTitle;
    
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didSelectFunctionIndexPath:(NSIndexPath *)indexPath withItem:(AbiinterfaceItem*) item andToken:(Contract*) token fromQStore:(BOOL)fromQStore {
    
    NSObject <ContractFunctionDetailOutput>* output = [[ControllersFactory sharedInstance] createTokenFunctionDetailViewController];
    output.function = item;
    output.delegate = self;
    output.token = token;
    output.fromQStore = fromQStore;
    self.functionDetailController = output;
    [self.navigationController pushViewController:[output toPresent] animated:true];
}

#pragma mark - QStoreContractOutputDelegate

- (void)didLoadFullContract:(QStoreShortContractElement *)element {
    [self.contractScreen startLoading];
    __weak typeof(self) weakSelf = self;
    [[QStoreManager sharedInstance] loadFullContractByShort:element withSuccessHandler:^(QStoreFullContractElement *fullElement) {
        [weakSelf.contractScreen stopLoading];
        [weakSelf.contractScreen setFullContract:fullElement];
    } andFailureHandler:^(NSString *message) {
        [weakSelf.contractScreen stopLoading];
    }];
}

- (void)didSelectQStoreContractDetails:(QStoreFullContractElement *)element {
    
}

- (void)didSelectTag:(NSString *)tag {
    [self.navigationController popViewControllerAnimated:YES];
    [self.mainScreen setTag:tag];
}

#pragma mark - ContractFunctionDetailOutputDelegate

- (void)didCallFunctionWithItem:(AbiinterfaceItem *)item andParam:(NSArray<ResultTokenInputsModel *> *)inputs andToken:(Contract *)token {
    
}

@end
