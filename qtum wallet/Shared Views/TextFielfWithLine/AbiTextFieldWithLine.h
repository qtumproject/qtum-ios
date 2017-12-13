//
//  AbiTextFieldWithLine.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 17.05.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "TextFieldWithLine.h"
#import "AbiinterfaceInput.h"
#import "AbiTextFieldWithLineDelegate.h"
#import "ParameterInputFieldProtocol.h"

@interface AbiTextFieldWithLine : TextFieldWithLine <ParameterInputFieldProtocol>

@end
