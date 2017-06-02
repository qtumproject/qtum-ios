//
//  CreateTokenFinishViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ResultTokenInputsModel;

@protocol ContractCoordinatorDelegate;

@interface CreateTokenFinishViewController : BaseViewController

@property (weak,nonatomic) id <ContractCoordinatorDelegate> delegate;
@property (strong,nonatomic) NSArray<ResultTokenInputsModel*>* inputs;

@end
