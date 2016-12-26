//
//  UIViewController+Extension.m
//  qtum wallet
//
//  Created by Никита Федоренко on 26.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

+ (UIViewController*) instantiateControllerInStoryboard:(UIStoryboard*) storyboard withIdentifire:(NSString*) identifire{
    return [storyboard instantiateInitialViewController];
//    return [storyboard instantiateViewControllerWithIdentifier:identifire];
}

+ (UIViewController*) controllerInStoryboard:(UIStoryboard*) storyboard withIdentifire:(NSString*) identifire{
    return [self instantiateControllerInStoryboard:storyboard withIdentifire:identifire];
}

- (UIViewController*) controllerInStoryboard:(UIStoryboard*) storyboard{
    return [UIViewController instantiateControllerInStoryboard:storyboard withIdentifire:self.nameOfClass];
}

@end
