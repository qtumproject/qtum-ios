//
//  SecurityPopupViewControllerDark.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 31.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "SecurityPopupViewControllerDark.h"

@interface SecurityPopupViewControllerDark ()

@end

@implementation SecurityPopupViewControllerDark

-(void)configPasswordView {
    
    [self.passwordView setStyle:DarkPopupStyle lenght:SLocator.appSettings.isLongPin ? LongType : ShortType];
    self.passwordView.delegate = self;
}

@end
