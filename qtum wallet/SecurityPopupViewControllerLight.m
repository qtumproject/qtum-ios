//
//  SecurityPopupViewControllerLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 31.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "SecurityPopupViewControllerLight.h"

@interface SecurityPopupViewControllerLight ()

@end

@implementation SecurityPopupViewControllerLight

-(void)configPasswordView {
    
    [self.passwordView setStyle:LightPopupStyle
                         lenght:SLocator.appSettings.isLongPin ? LongType : ShortType];
    
    self.passwordView.delegate = self;
}

@end
