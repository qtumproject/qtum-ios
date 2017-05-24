//
//  CreateTokenFinishViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.05.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ResultTokenInputsModel;

@protocol CreateTokenCoordinatorDelegate;

@interface CreateTokenFinishViewController : UIViewController

@property (weak,nonatomic) id <CreateTokenCoordinatorDelegate> delegate;
@property (strong,nonatomic) NSArray<ResultTokenInputsModel*>* inputs;

@end
