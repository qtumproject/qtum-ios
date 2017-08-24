//
//  QStoreCoordinator.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "QStoreCoordinator.h"

#import "QStoreMainOutput.h"
#import "QStoreContractOutput.h"
#import "QStoreListOutput.h"
#import "ContractFunctionDetailOutput.h"
#import "QStoreContractElement.h"
#import "QStoreManager.h"
#import "QStoreCategory.h"
#import "QStoreBuyRequest.h"

@interface QStoreCoordinator() <QStoreMainOutputDelegate, QStoreContractOutputDelegate, ContractFunctionDetailOutputDelegate, QStoreManagerSearchDelegate, QStoreListOutputDelegate>

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
        [QStoreManager sharedInstance].delegate = self;
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
    NSObject<QStoreListOutput> *controller = (NSObject<QStoreListOutput> *)[[ControllersFactory sharedInstance] createQStoreListViewController];
    controller.delegate = self;
    controller.type = QStoreCategories;
    [controller setCategories:[QStoreManager sharedInstance].categories];
    
    [self.navigationController pushViewController:[controller toPresent] animated:YES];
}

- (void)didSelectQStoreContractElement:(QStoreContractElement *)element {
    
    NSObject<QStoreContractOutput> *controller = (NSObject<QStoreContractOutput> *)[[ControllersFactory sharedInstance] createQStoreContractViewController];
    self.contractScreen = controller;
    [controller setBuyRequest:[[QStoreManager sharedInstance] requestWithContractId:element.idString]];
    [controller setContract:element];
    controller.delegate = self;
    
    [self.navigationController pushViewController:[controller toPresent] animated:YES];
}

- (void)didSelectQStoreContractDetails {
    [self didSelectFunctionIndexPath:nil withItem:nil andToken:nil fromQStore:YES];
}

- (void)didLoadCategories {
    [self.mainScreen startLoading];
    __weak typeof(self) weakSelt = self;
    [[QStoreManager sharedInstance] loadContractsForCategoriesWithSuccessHandler:^(NSArray<QStoreCategory *> *categories) {
        [weakSelt.mainScreen stopLoading];
        [weakSelt.mainScreen setCategories:categories];
    } andFailureHandler:^(NSString *message) {
        [weakSelt.mainScreen stopLoading];
    }];
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

- (void)didChangedSearchText:(NSString *)text orSelectedSearchIndex:(NSInteger)index {
    [[QStoreManager sharedInstance] searchByString:text searchType:[self getSearchTypeByIndex:index]];
}

- (void)didLoadMoreElementsForText:(NSString *)text orSelectedSearchIndex:(NSInteger)index {
    [[QStoreManager sharedInstance] searchMoreItemsByString:text searchType:[self getSearchTypeByIndex:index]];
}

- (QStoreManagerSearchType)getSearchTypeByIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return QStoreManagerSearchTypeName;
            break;
        case 1:
            return QStoreManagerSearchTypeTag;
            break;
        default:
            return QStoreManagerSearchTypeNone;
            break;
    }
}

#pragma mark - QStoreManagerSearchDelegate

- (void)didFindElements:(NSArray<QStoreContractElement *> *)elements {
    [self.mainScreen setSearchElements:elements];
}

- (void)didFindMoreElements:(NSArray<QStoreContractElement *> *)elements {
    [self.mainScreen setSearchMoreElements:elements];
}

#pragma mark - QStoreContractOutputDelegate

- (void)didLoadViewWithFullContract:(QStoreContractElement *)element {
    
    [self.contractScreen startLoading];
    __weak typeof(self) weakSelf = self;
    
    [[QStoreManager sharedInstance] loadFullContract:element withSuccessHandler:^{
        [weakSelf.contractScreen stopLoading];
        [weakSelf.contractScreen updateWithFull];
    } andFailureHandler:^(NSString *message) {
        [weakSelf.contractScreen stopLoading];
    }];
}

- (void)didLoadAbi:(QStoreContractElement *)element {
    
    [self.contractScreen startLoading];
    
    __weak typeof(self) weakSelf = self;
    [[QStoreManager sharedInstance] getContractABIWithElement:element withSuccessHandler:^{
        [weakSelf.contractScreen stopLoading];
        [weakSelf.contractScreen showAbi];
    } andFailureHandler:^(NSString *message) {
        [weakSelf.contractScreen stopLoading];
    }];
}

- (void)didSelectQStoreContractDetails:(QStoreBuyRequest *)request {
    
    __weak typeof(self) weakSelf = self;
    
    [self.contractScreen startLoading];

    [[QStoreManager sharedInstance] getSourceCode:request.contractId requestId:request.requestId accessToken:request.accessToken withSuccessHandler:^(NSString *sourceCode) {
        [weakSelf.contractScreen stopLoading];
        [weakSelf.contractScreen showSourceCode:sourceCode];
    } andFailureHandler:^(NSError *error, NSString *message) {
        [weakSelf.contractScreen stopLoading];
    }];
}

- (void)didSelectTag:(NSString *)tag {
    [self.navigationController popToViewController:[self.mainScreen toPresent] animated:YES];
    [self.mainScreen setTag:tag];
}

- (void)didSelectPurchaseContract:(QStoreContractElement *)element {
    
    [self.contractScreen startLoading];
    
    __weak typeof(self) weakSelf = self;
    
    [[QStoreManager sharedInstance] purchaseContract:element withSuccessHandler:^{
        [weakSelf.contractScreen stopLoading];
        [weakSelf.contractScreen setBuyRequest:[[QStoreManager sharedInstance] requestWithContractId:element.idString]];
        [weakSelf.contractScreen updateWithFull];
        [weakSelf.contractScreen showContractBoughtPop];
    } andFailureHandler:^(NSString *message) {
        [weakSelf.contractScreen stopLoading];
        [weakSelf.contractScreen showErrorPopUpWithMessage:message];
    }];
}

- (void)didCopySourceOrAbi:(NSString *) text {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = text;
}

#pragma mark - QStoreListOutputDelegate

- (void)didSelectQStoreCategory:(QStoreCategory *)category {
    
    NSObject<QStoreListOutput> *controller = (NSObject<QStoreListOutput> *)[[ControllersFactory sharedInstance] createQStoreListViewController];
    controller.delegate = self;
    controller.type = QStoreContracts;
    controller.categoryTitle = category.title;
    [controller setElements:category.elements];
    
    [self.navigationController pushViewController:[controller toPresent] animated:YES];
}

- (void)didSelectQStoreContract:(QStoreContractElement *)element {
    [self didSelectQStoreContractElement:element];
}

#pragma mark - ContractFunctionDetailOutputDelegate

- (void)didCallFunctionWithItem:(AbiinterfaceItem *)item andParam:(NSArray<ResultTokenInputsModel *> *)inputs andToken:(Contract *)token {
    
}

@end
