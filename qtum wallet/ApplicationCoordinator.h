//
//  ApplicationCoordinator.h
//  qtum wallet
//
//  Created by Никита Федоренко on 13.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface ApplicationCoordinator : NSObject

@property (strong,nonatomic) AppDelegate* appDelegate;

-(instancetype)initWithAppDelegate:(AppDelegate*) appDelegate;
-(void)start;

@end
