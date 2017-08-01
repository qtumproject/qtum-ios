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
-(void)didPressedBack;
-(void)didSelectQStoreCategories;
-(void)didSelectQStoreCategory;
-(void)didSelectQStoreContract;
-(void)didSelectQStoreContractDetails;
-(void)didSelectFunctionIndexPath:(NSIndexPath *)indexPath withItem:(AbiinterfaceItem*) item andToken:(Contract*) token;
-(void)didDeselectFunctionIndexPath:(NSIndexPath *)indexPath withItem:(AbiinterfaceItem*) item;

- (void)didSelectChooseFromLibrary:(id)sender;
- (void)didChangeAbiText;


@end

@interface ContractCoordinator : BaseCoordinator <Coordinatorable,ContractCoordinatorDelegate>

-(instancetype)initWithNavigationController:(UINavigationController*)navigationController;

@end
