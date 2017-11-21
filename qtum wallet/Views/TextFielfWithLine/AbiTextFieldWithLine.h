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

@interface AbiTextFieldWithLine : TextFieldWithLine

- (instancetype)initWithFrame:(CGRect) frame andInterfaceItem:(AbiinterfaceInput *) item;

@property (weak, nonatomic) id <AbiTextFieldWithLineDelegate> customDelegate;
@property (strong, nonatomic) AbiinterfaceInput *item;

@end
