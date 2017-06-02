//
//  ProfileViewController.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 28.12.16.
//  Copyright © 2016 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LanguageCoordinator;

@interface ProfileViewController : BaseViewController

- (void)saveLanguageCoordinator:(LanguageCoordinator *)languageCoordinator;

@end
