//
//  AbiTextFieldWithLineLight.h
//  qtum wallet
//
//  Created by Никита Федоренко on 01.08.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "TextFieldWithLineLightSend.h"
#import "AbiinterfaceInput.h"
#import "AbiTextFieldWithLineDelegate.h"

@interface AbiTextFieldWithLineLight : TextFieldWithLineLightSend

-(instancetype)initWithFrame:(CGRect)frame andInterfaceItem:(AbiinterfaceInput*) item;

@property (weak, nonatomic) id <AbiTextFieldWithLineDelegate> customDelegate;
@property (strong, nonatomic) AbiinterfaceInput* item;

@end
