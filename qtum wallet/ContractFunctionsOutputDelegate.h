//
//  ContractFunctionsOutputDelegate.h
//  qtum wallet
//
//  Created by Никита Федоренко on 01.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ContractFunctionsOutputDelegate <NSObject>

-(void)didSelectFunctionIndexPath:(NSIndexPath *)indexPath withItem:(AbiinterfaceItem*) item andToken:(Contract*) token;
-(void)didDeselectFunctionIndexPath:(NSIndexPath *)indexPath withItem:(AbiinterfaceItem*) item;

@end
