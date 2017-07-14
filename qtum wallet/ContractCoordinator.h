//
//  ContractCoordinator.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.03.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCoordinator.h"
#import "ResultTokenInputsModel.h"
@class TemplateModel;
@class AbiinterfaceItem;

@protocol ContractCoordinatorDelegate <NSObject>

@required
-(void)createStepOneCancelDidPressed;
-(void)createStepOneNextDidPressedWithInputs:(NSArray<ResultTokenInputsModel*>*) inputs;
-(void)finishStepFinishDidPressed;
-(void)finishStepBackDidPressed;
-(void)didSelectContractStore;
-(void)didSelectWatchContracts;
-(void)didSelectWatchTokens;
-(void)didSelectPublishedContracts;
-(void)didSelectNewContracts;
-(void)didSelectRestoreContract;
-(void)didSelectBackupContract;
-(void)didPressedQuit;
-(void)didPressedBack;
-(void)didSelectQStoreCategories;
-(void)didSelectQStoreCategory;
-(void)didSelectQStoreContract;
-(void)didSelectQStoreContractDetails;
-(void)didDeselectTemplateIndexPath:(NSIndexPath*) indexPath withName:(TemplateModel*) templateModel;
-(void)didSelectContractWithIndexPath:(NSIndexPath*) indexPath withContract:(Contract*) contract;
-(void)didSelectFunctionIndexPath:(NSIndexPath *)indexPath withItem:(AbiinterfaceItem*) item andToken:(Contract*) token;
-(void)didDeselectFunctionIndexPath:(NSIndexPath *)indexPath withItem:(AbiinterfaceItem*) item;
-(void)didCallFunctionWithItem:(AbiinterfaceItem*) item
                       andParam:(NSArray<ResultTokenInputsModel*>*)inputs
                       andToken:(Contract*) token;

- (void)didSelectChooseFromLibrary:(id)sender;

@end

@interface ContractCoordinator : BaseCoordinator <Coordinatorable,ContractCoordinatorDelegate>

-(instancetype)initWithNavigationController:(UINavigationController*)navigationController;

@end
