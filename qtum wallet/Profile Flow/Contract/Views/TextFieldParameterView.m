//
//  TextFieldParameterView.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "TextFieldParameterView.h"

@interface TextFieldParameterView ()

@end

@implementation TextFieldParameterView

- (BOOL)isValidParameter {
    
    return [self.textField isValidParameterText];
}

@end
