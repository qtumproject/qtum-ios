//
//  NewsCoordinator.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 02.03.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsCoordinator : BaseCoordinator <Coordinatorable>

-(instancetype)initWithNavigationController:(UINavigationController*)navigationController;

@end
