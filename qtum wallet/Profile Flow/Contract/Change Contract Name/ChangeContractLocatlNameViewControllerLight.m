//
//  ChangeContractLocatlNameViewControllerLight.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 30.01.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "ChangeContractLocatlNameViewControllerLight.h"
#import "TextFieldParameterView.h"

@interface ChangeContractLocatlNameViewControllerLight ()

@end

@implementation ChangeContractLocatlNameViewControllerLight

- (TextFieldWithLine*)changeNameTextFiled {

    TextFieldWithLine *textField = (TextFieldWithLine *)[[[NSBundle mainBundle] loadNibNamed:@"TextFieldWithLineLightSend" owner:self options:nil] lastObject];
    return textField;
}

@end
