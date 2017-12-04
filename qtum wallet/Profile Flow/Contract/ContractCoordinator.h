//
//  ContractCoordinator.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.03.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCoordinator.h"
#import "ResultTokenInputsModel.h"

@class TemplateModel;
@class AbiinterfaceItem;

@protocol ContractCoordinatorDelegate <NSObject>

@required
- (void)createStepOneCancelDidPressed;

- (void)didPressedBack;

- (void)didSelectChooseFromLibrary:(id) sender;

- (void)didChangeAbiText;


@end

@interface ContractCoordinator : BaseCoordinator <Coordinatorable, ContractCoordinatorDelegate>

- (instancetype)initWithNavigationController:(UINavigationController *) navigationController;

@end
