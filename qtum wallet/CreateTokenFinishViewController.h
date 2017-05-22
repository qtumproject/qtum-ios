//
//  CreateTokenFinishViewController.h
//  qtum wallet
//
//  Created by Никита Федоренко on 17.05.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ResultTokenCreateInputModel;

@protocol CreateTokenCoordinatorDelegate;

@interface CreateTokenFinishViewController : UIViewController

@property (weak,nonatomic) id <CreateTokenCoordinatorDelegate> delegate;
@property (strong,nonatomic) NSArray<ResultTokenCreateInputModel*>* inputs;

@end
