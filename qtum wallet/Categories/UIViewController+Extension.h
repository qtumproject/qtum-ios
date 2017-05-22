//
//  UIViewController+Extension.h
//  qtum wallet
//
//  Created by Никита Федоренко on 26.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extension)

+ (UIViewController*) controllerInStoryboard:(NSString*) storyboard withIdentifire:(NSString*) identifire;
- (UIViewController*)controllerInStoryboard:(NSString*) storyboard;


@end
