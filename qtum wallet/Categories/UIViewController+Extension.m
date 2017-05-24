//
//  UIViewController+Extension.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 26.12.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

+ (UIViewController*) instantiateControllerInStoryboard:(UIStoryboard*) storyboard withIdentifire:(NSString*) identifire{
    return identifire ? [storyboard instantiateViewControllerWithIdentifier:identifire] : [storyboard instantiateInitialViewController];
}

+ (UIViewController*) controllerInStoryboard:(NSString*) storyboard withIdentifire:(NSString*) identifire{
    return [self instantiateControllerInStoryboard:[UIStoryboard storyboardWithName:storyboard bundle:nil] withIdentifire:identifire];
}

- (UIViewController*) controllerInStoryboard:(NSString*) storyboard{
    return [UIViewController instantiateControllerInStoryboard:[UIStoryboard storyboardWithName:storyboard bundle:nil]  withIdentifire:self.nameOfClass];
}

@end
