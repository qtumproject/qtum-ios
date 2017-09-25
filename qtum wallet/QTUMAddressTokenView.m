//
//  QTUMAddressTokenView.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 29.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "QTUMAddressTokenView.h"

@implementation QTUMAddressTokenView

- (IBAction)actionPlus:(id)sender {
    [self.delegate actionPlus:sender];
}

- (IBAction)actionTokenAddressControl:(id)sender {
    [self.delegate actionTokenAddressControl];
}

@end
