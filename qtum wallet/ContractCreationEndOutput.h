//
//  ContractCreationEndOutput.h
//  qtum wallet
//
//  Created by Никита Федоренко on 01.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Presentable.h"
#import "ContractCreationEndOutputDelegate.h"
#import "ResultTokenInputsModel.h"

@protocol ContractCreationEndOutput <Presentable>

@property (weak,nonatomic) id <ContractCreationEndOutputDelegate> delegate;
@property (copy,nonatomic) NSArray<ResultTokenInputsModel*>* inputs;

- (void)showErrorPopUp;
- (void)showCompletedPopUp;

@end
