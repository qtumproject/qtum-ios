//
//  TextFieldParameterView.h
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbiTextFieldWithLine.h"

@interface TextFieldParameterView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet AbiTextFieldWithLine *textField;

@end
