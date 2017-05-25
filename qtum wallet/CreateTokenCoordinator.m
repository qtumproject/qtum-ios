//
//  CreateTokenCoordinator.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 03.03.17.
//  Copyright © 2017 Designsters. All rights reserved.
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


@interface CreateTokenCoordinator ()

@property (strong, nonatomic) UINavigationController* navigationController;
@property (strong, nonatomic) UINavigationController* modalNavigationController;
@property (strong,nonatomic) NSArray<ResultTokenInputsModel*>* inputs;
@property (strong,nonatomic) NSString* templateName;

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
    
    TemplateTokenViewController* controller = (TemplateTokenViewController*)[[ControllersFactory sharedInstance] createTemplateTokenViewController];
    controller.delegate = self;
    controller.templateNames = [ContractFileManager getAvailebaleTemplates];
    CreateTokenNavigationController* modal = [[CreateTokenNavigationController alloc] initWithRootViewController:controller];
    self.modalNavigationController = modal;
    [self.navigationController presentViewController:modal animated:YES completion:nil];
}

#pragma mark - Private Methods 

-(void)showStepWithFieldsAndTemplate:(NSString*)template{
    CustomAbiInterphaseViewController* controller = (CustomAbiInterphaseViewController*)[[ControllersFactory sharedInstance] createCustomAbiInterphaseViewController];
    controller.delegate = self;
    
    controller.formModel = [[ContractManager sharedInstance] getTokenInterfaceWithTemplate:self.templateName];

    [self.modalNavigationController pushViewController:controller animated:YES];
}

-(void)showFinishStepWithInputs:(NSArray<ResultTokenInputsModel*>*) inputs{
    CreateTokenFinishViewController* controller = (CreateTokenFinishViewController*)[[ControllersFactory sharedInstance] createCreateTokenFinishViewController];
    controller.delegate = self;
    self.inputs = inputs;
    controller.inputs = inputs;
    [self.modalNavigationController pushViewController:controller animated:YES];
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

-(void)finishStepBackDidPressed{
    [self.modalNavigationController popViewControllerAnimated:YES];
}

-(void)finishStepFinishDidPressed{

    __weak __typeof(self)weakSelf = self;
    [SVProgressHUD show];
    
    NSData* contractWithArgs = [[ContractManager sharedInstance] getTokenBitecodeWithTemplate:self.templateName andArray:[self argsFromInputs]];
    
    [[TransactionManager sharedInstance] createSmartContractWithKeys:[WalletManager sharedInstance].getCurrentWallet.getAllKeys andBitcode:contractWithArgs andHandler:^(NSError *error, BTCTransaction *transaction, NSString* hashTransaction) {
        if (!error) {
            BTCTransactionInput* input = transaction.inputs[0];
            NSLog(@"%@",input.runTimeAddress);
            [[TokenManager sharedInstance] addSmartContractPretendent:@[input.runTimeAddress] forKey:hashTransaction withTemplate:self.templateName];
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Done", "")];
        } else {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Failed", "")];
            NSLog(@"Failed Request");
        }
        [weakSelf.modalNavigationController dismissViewControllerAnimated:YES completion:nil];
        
    }];

    [self.modalNavigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)didDeselectTemplateIndexPath:(NSIndexPath*) indexPath withName:(NSString*) templateName {
    self.templateName = templateName;
    [self showStepWithFieldsAndTemplate:templateName];
}

@end
