//
//  ContractCreationEndOutputDelegate.h
//  qtum wallet
//
//  Created by Никита Федоренко on 01.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ContractCreationEndOutputDelegate <NSObject>

- (void)didPressedQuit;
- (void)finishStepFinishDidPressed;
- (void)finishStepBackDidPressed;

@end
