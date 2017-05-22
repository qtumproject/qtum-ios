//
//  Coordinatorable.h
//  qtum wallet
//
//  Created by Никита Федоренко on 21.02.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Coordinatorable <NSObject>

@required
-(void)start;

@optional
-(instancetype)initWithViewController:(UIViewController*)viewController;

@end
