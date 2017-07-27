//
//  SubscribeTokenOutputDelegate.h
//  qtum wallet
//
//  Created by Никита Федоренко on 27.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SubscribeTokenOutputDelegate <NSObject>

-(void)didBackButtonPressed;
-(void)didSelectContract:(Contract*) contract;

@end
