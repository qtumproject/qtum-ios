//
//  AbiTextFieldWithLineLight.h
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 01.08.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "TextFieldWithLineLightSend.h"
#import "AbiinterfaceInput.h"
#import "AbiTextFieldWithLineDelegate.h"
#import "ParameterInputFieldProtocol.h"

@interface AbiTextFieldWithLineLight : TextFieldWithLineLightSend <ParameterInputFieldProtocol>

@end
