//
//  ContractFunctionDetailOutputDelegate.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 01.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbiinterfaceItem.h"
#import "ResultTokenInputsModel.h"

@protocol ContractFunctionDetailOutputDelegate <NSObject>

-(void)didCallFunctionWithItem:(AbiinterfaceItem*) item
                      andParam:(NSArray<ResultTokenInputsModel*>*)inputs
                      andToken:(Contract*) token;

@end
