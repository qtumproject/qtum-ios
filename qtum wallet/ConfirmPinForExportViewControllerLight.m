//
//  ConfirmPinForExportViewControllerLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 12.07.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "ConfirmPinForExportViewControllerLight.h"

@interface ConfirmPinForExportViewControllerLight ()

@end

@implementation ConfirmPinForExportViewControllerLight


-(void)configPasswordView {
    
    [self.passwordView setStyle:LightStyle lenght:[AppSettings sharedInstance].isLongPin ? LongType : ShortType];
    self.passwordView.delegate = self;
}

@end
