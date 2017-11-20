//
//  ProfileCoordinator.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 07.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "BaseCoordinator.h"

@class LanguageCoordinator;

@interface ProfileCoordinator : BaseCoordinator <Coordinatorable>

- (instancetype)initWithNavigationController:(UINavigationController *) navigationController;

- (void)startFromLanguage;

@end
