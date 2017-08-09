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
#import "QStoreContractViewController.h"

#import "QStoreManager.h"

@interface QStoreCoordinator() <QStoreMainOutputDelegate, ContractFunctionDetailOutputDelegate>

@property (strong, nonatomic) UINavigationController* navigationController;

@property (strong, nonatomic) NSObject<QStoreMainOutput> *mainScreen;
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

- (void)didSelectQStoreContract {
    [self showQStoreContract];
}

- (void)didSelectQStoreContractDetails {
    [self didSelectFunctionIndexPath:nil withItem:nil andToken:nil fromQStore:YES];
}

- (void)didLoadTrendingNow {
    [self.mainScreen startLoading];
    __weak typeof(self) weakSelt = self;
    [[QStoreManager sharedInstance] loadContractsForCategoriesWithSuccessHandler:^(NSArray<QStoreCategory *> *categories) {
        NSLog(@"%@", categories);
        [weakSelt.mainScreen stopLoading];
        [weakSelt.mainScreen setCategories:categories];
    } andFailureHandler:^(NSString *message) {
        NSLog(@"%@", message);
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

-(void)showQStoreContract {
    
    QStoreContractViewController* controller = (QStoreContractViewController*)[[ControllersFactory sharedInstance] createQStoreContractViewController];
    controller.delegate = self;
    
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

#pragma mark - ContractFunctionDetailOutputDelegate

- (void)didCallFunctionWithItem:(AbiinterfaceItem *)item andParam:(NSArray<ResultTokenInputsModel *> *)inputs andToken:(Contract *)token {
    
}

@end
