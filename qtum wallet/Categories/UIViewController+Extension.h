//
//  UIViewController+Extension.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 26.12.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extension)

+ (UIViewController *)controllerInStoryboard:(NSString *) storyboard withIdentifire:(NSString *) identifire;

- (UIViewController *)controllerInStoryboard:(NSString *) storyboard;


@end
