//
//  LanguageOutputDelegate.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 10.07.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LanguageOutputDelegate <NSObject>

- (void)didLanguageChanged;
- (void)didBackPressed;

@end
