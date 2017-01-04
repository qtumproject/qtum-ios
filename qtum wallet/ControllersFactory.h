//
//  ControllersFactory.h
//  qtum wallet
//
//  Created by Никита Федоренко on 26.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ControllersFactory : NSObject

+ (instancetype)sharedInstance;
- (id)init __attribute__((unavailable("cannot use init for this class, use sharedInstance instead")));
+ (instancetype)alloc __attribute__((unavailable("alloc not available, call sharedInstance instead")));
+ (instancetype) new __attribute__((unavailable("new not available, call sharedInstance instead")));

-(UIViewController*)profileFlowTab;
-(UIViewController*)newsFlowTab;
-(UIViewController*)sendFlowTab;
-(UIViewController*)walletFlowTab;
-(UIViewController*)changePinFlowController;
-(UIViewController*)createPinFlowController;
-(UIViewController*)createWalletFlowController;

-(UIViewController*)createFlowNavigationCoordinator;
-(UIViewController*)createTabFlow;


@end
