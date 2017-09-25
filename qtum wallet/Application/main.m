//
//  main.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 29.10.16.
//  Copyright © 2016 QTUM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    
    @autoreleasepool {
        [LanguageManager setupCurrentLanguage];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
