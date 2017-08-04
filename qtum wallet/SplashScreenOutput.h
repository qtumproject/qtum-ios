//
//  SplashScreenOutput.h
//  qtum wallet
//
//  Created by Никита Федоренко on 04.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Presentable.h"
#import "SplashScreenOutputDelegate.h"

@protocol SplashScreenOutput <Presentable>

@property (weak, nonatomic) id <SplashScreenOutputDelegate> delegate;

@end
