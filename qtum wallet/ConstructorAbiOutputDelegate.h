//
//  ConstructorAbiOutputDelegate.h
//  qtum wallet
//
//  Created by Никита Федоренко on 01.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResultTokenInputsModel.h"

@protocol ConstructorAbiOutputDelegate <NSObject>

-(void)createStepOneNextDidPressedWithInputs:(NSArray<ResultTokenInputsModel*>*) inputs andContractName:(NSString*) contractName;
-(void)didPressedBack;

@end
