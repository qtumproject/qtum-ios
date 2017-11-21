//
//  QStoreCoordinator.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QStoreCoordinator.h"

#import "QStoreMainOutput.h"
#import "QStoreContractOutput.h"
#import "QStoreListOutput.h"
#import "ContractFunctionDetailOutput.h"
#import "QStoreContractElement.h"
#import "QStoreMainScreenCategory.h"
#import "QStoreBuyRequest.h"
#import "QStoreTemplateDetailOutput.h"
#import "InterfaceInputFormModel.h"
#import "SourceCodeOutput.h"


@interface QStoreCoordinator() <QStoreMainOutputDelegate, QStoreContractOutputDelegate, ContractFunctionDetailOutputDelegate, QStoreManagerSearchDelegate, QStoreListOutputDelegate, QStoreTemplateDetailOutputDelegate, SourceCodeOutputDelegate>

@property (strong, nonatomic) UINavigationController* navigationController;

@property (strong, nonatomic) NSObject<QStoreMainOutput> *mainScreen;
@property (strong, nonatomic) NSObject<QStoreContractOutput> *contractScreen;
@property (strong, nonatomic) NSObject<ContractFunctionDetailOutput> *functionDetailController;

@property (nonatomic, weak) NSObject<QStoreListOutput> *listOutput;

@end

@implementation QStoreCoordinator

- (instancetype)initWithNavigationController:(UINavigationController*)navigationController {
    self = [super init];
    if (self) {
        _navigationController = navigationController;
        SLocator.qStoreManager.delegate = self;
    }
    return self;
}

#pragma mark - Coordinatorable

- (void)start {
    
    NSObject<QStoreMainOutput> *mainScreen = (NSObject<QStoreMainOutput> *)[SLocator.controllersFactory createQStoreMainViewController];
    mainScreen.delegate = self;
    self.mainScreen = mainScreen;
    [self.navigationController pushViewController:[mainScreen toPresent] animated:YES];
}

-(void)showSourceScreenCodeWithSorceCode:(NSString*) sourceCode {
    
    NSObject<SourceCodeOutput>* output = [SLocator.controllersFactory createSourceCodeOutput];
    output.delegate = self;
    NSAttributedString* formattedSourceCode = [SLocator.sourceCodeFormatService formattingSourceCodeStringWithString:sourceCode];
    output.sourceCode = formattedSourceCode;
    [self.navigationController pushViewController:[output toPresent] animated:YES];
}

#pragma mark - For all delegates

- (void)didPressedBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - QStoreMainOutputDelegate

- (void)didSelectQStoreCategories {
    NSObject<QStoreListOutput> *controller = (NSObject<QStoreListOutput> *)[SLocator.controllersFactory createQStoreListViewController];
    controller.delegate = self;
    controller.type = QStoreCategories;
    
    [self.navigationController pushViewController:[controller toPresent] animated:YES];
}

- (void)didSelectQStoreContractElement:(QStoreContractElement *)element {
    
    NSObject<QStoreContractOutput> *controller = (NSObject<QStoreContractOutput> *)[SLocator.controllersFactory createQStoreContractViewController];
    self.contractScreen = controller;
    [controller setBuyRequest:[SLocator.qStoreManager requestWithContractId:element.idString]];
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
    [SLocator.qStoreManager loadContractsForCategoriesWithSuccessHandler:^(NSArray<QStoreMainScreenCategory *> *categories) {
        [weakSelt.mainScreen stopLoading];
        [weakSelt.mainScreen setCategories:categories];
    } andFailureHandler:^(NSString *message) {
        [weakSelt.mainScreen stopLoading];
    }];
}

- (void)didSelectFunctionIndexPath:(NSIndexPath *)indexPath withItem:(AbiinterfaceItem*) item andToken:(Contract*) token fromQStore:(BOOL)fromQStore {
    
    NSObject <ContractFunctionDetailOutput>* output = [SLocator.controllersFactory createTokenFunctionDetailViewController];
    output.function = item;
    output.delegate = self;
    output.token = token;
    output.fromQStore = fromQStore;
    self.functionDetailController = output;
    [self.navigationController pushViewController:[output toPresent] animated:true];
}

- (void)didChangedSearchText:(NSString *)text orSelectedSearchIndex:(NSInteger)index {
    [SLocator.qStoreManager searchByCategoryType:nil string:text searchType:[self getSearchTypeByIndex:index]];
}

- (void)didLoadMoreElementsForText:(NSString *)text orSelectedSearchIndex:(NSInteger)index {
    [SLocator.qStoreManager searchMoreItemsByCategoryType:nil string:text searchType:[self getSearchTypeByIndex:index]];
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
    if (self.listOutput) {
        [self.listOutput setElements:elements];
        return;
    }
    
    [self.mainScreen setSearchElements:elements];
}

- (void)didFindMoreElements:(NSArray<QStoreContractElement *> *)elements {
    if (self.listOutput) {
        [self.listOutput setMoreElements:elements];
        return;
    }
    [self.mainScreen setSearchMoreElements:elements];
}

#pragma mark - QStoreContractOutputDelegate

- (void)didLoadViewWithFullContract:(QStoreContractElement *)element {
    
    [self.contractScreen startLoading];
    __weak typeof(self) weakSelf = self;
    
    [SLocator.qStoreManager loadFullContract:element withSuccessHandler:^{
        [weakSelf.contractScreen stopLoading];
        [weakSelf.contractScreen updateWithFull];
    } andFailureHandler:^(NSString *message) {
        [weakSelf.contractScreen stopLoading];
    }];
}

- (void)loadAbiWithElement:(QStoreContractElement *)element {
    
    [self.contractScreen startLoading];
    
    __weak typeof(self) weakSelf = self;
    [SLocator.qStoreManager getContractABIWithElement:element withSuccessHandler:^{
        [weakSelf.contractScreen stopLoading];
        [weakSelf.contractScreen didLoadAbi];
    } andFailureHandler:^(NSString *message) {
        [weakSelf.contractScreen stopLoading];
    }];
}

- (void)didSelectQStoreContractDetails:(QStoreBuyRequest *)request {
    
    __weak typeof(self) weakSelf = self;
    
    [self.contractScreen startLoading];

    [SLocator.qStoreManager getSourceCode:request.contractId requestId:request.requestId accessToken:request.accessToken withSuccessHandler:^(NSString *sourceCode) {
        [weakSelf.contractScreen stopLoading];
        [weakSelf showSourceScreenCodeWithSorceCode:sourceCode];
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
    
    [SLocator.qStoreManager purchaseContract:element withSuccessHandler:^{
        [weakSelf.contractScreen stopLoading];
        [weakSelf.contractScreen setBuyRequest:[SLocator.qStoreManager requestWithContractId:element.idString]];
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

- (void)didPressedTemplateDetailWithAbi:(NSString*) abi {
    
    NSObject<QStoreTemplateDetailOutput> *output = [SLocator.controllersFactory createQStoreTemplateDetailOutput];
    output.delegate = self;
    InterfaceInputFormModel* interfaceInput = [[InterfaceInputFormModel alloc] initWithAbi:[SLocator.contractInterfaceManager arrayFromAbiString:abi]];
    output.formModel = interfaceInput;
    [self.navigationController pushViewController:[output toPresent] animated:YES];
}

#pragma mark - QStoreListOutputDelegate

- (void)didSelectQStoreCategory:(QStoreCategory *)category {
    
    NSObject<QStoreListOutput> *controller = (NSObject<QStoreListOutput> *)[SLocator.controllersFactory createQStoreListViewController];
    controller.delegate = self;
    controller.type = QStoreContracts;
    controller.categoryTitle = category.name;
    controller.categoryType = category.name;
    
    self.listOutput = controller;
    
    [self.navigationController pushViewController:[controller toPresent] animated:YES];
}

- (void)didSelectQStoreContract:(QStoreContractElement *)element {
    [self didSelectQStoreContractElement:element];
}

- (void)didLoadFullData:(NSObject<QStoreListOutput> *)output {
    
    if (output.type == QStoreCategories) {
        [output startLoading];
        [SLocator.qStoreManager loadCategoriesWithSuccessHandler:^(NSArray<QStoreCategory *> *categories) {
            [output endLoading];
            [output setCategories:categories];
        } andFailureHandler:^(NSString *message) {
            [output endLoading];
            [output showErrorWithMessage:message];
        }];
    } else {
        [SLocator.qStoreManager searchByCategoryType:output.categoryType string:nil searchType:QStoreManagerSearchTypeAll];
    }
}

- (void)didLoadMoreFullData:(NSObject<QStoreListOutput> *)output {
    if (output.type != QStoreCategories) {
        [SLocator.qStoreManager searchMoreItemsByCategoryType:output.categoryType string:nil searchType:QStoreManagerSearchTypeAll];
    }
}

- (void)didChangedSearchText:(NSString *)text orSelectedSearchIndex:(NSInteger)index output:(NSObject<QStoreListOutput> *)output {
    if (output.type == QStoreCategories) {
        if (text.length > 0) {
            [SLocator.qStoreManager loadCategoriesWithSuccessHandler:^(NSArray<QStoreCategory *> *categories) {
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[c] %@", text];
                NSArray *filteredArray = [categories filteredArrayUsingPredicate:predicate];
                filteredArray = [filteredArray sortedArrayUsingComparator:^NSComparisonResult(QStoreCategory *obj1, QStoreCategory *obj2) {
                    NSInteger i1 = [obj1.name rangeOfString:text options:NSCaseInsensitiveSearch].location;
                    NSInteger i2 = [obj2.name rangeOfString:text options:NSCaseInsensitiveSearch].location;
                    
                    return i1 < i2 ? NSOrderedAscending : i1 == i2 ? NSOrderedSame : NSOrderedDescending;
                }];
                [output setCategories:filteredArray];
            } andFailureHandler:nil];
        } else {
            [SLocator.qStoreManager loadCategoriesWithSuccessHandler:^(NSArray<QStoreCategory *> *categories) {
                [output setCategories:categories];
            } andFailureHandler:nil];
        }
    } else {
        if ([text isEqualToString:@""]) {
            [self didLoadFullData:output];
        } else {
            [SLocator.qStoreManager searchByCategoryType:output.categoryType string:text searchType:[self getSearchTypeByIndex:index]];
        }
    }
}

- (void)didLoadMoreElementsForText:(NSString *)text orSelectedSearchIndex:(NSInteger)index output:(NSObject<QStoreListOutput> *)output {
    if (output.type != QStoreCategories) {
        if ([text isEqualToString:@""]) {
            [self didLoadMoreFullData:output];
        } else {
            [SLocator.qStoreManager searchMoreItemsByCategoryType:output.categoryType string:text searchType:[self getSearchTypeByIndex:index]];
        }
    }
}

#pragma mark - ContractFunctionDetailOutputDelegate

- (void)didCallFunctionWithItem:(AbiinterfaceItem *)item andParam:(NSArray<ResultTokenInputsModel *> *)inputs andToken:(Contract *)token {
    
}

@end
