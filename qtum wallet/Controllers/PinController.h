//
//  PinController.h
//  qtum wallet
//
//  Created by Никита Федоренко on 05.01.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"

@interface PinController : UIViewController

@property (weak, nonatomic) IBOutlet CustomTextField *firstSymbolTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *secondSymbolTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *thirdSymbolTextField;
@property (weak, nonatomic) IBOutlet CustomTextField *fourthSymbolTextField;
@property (weak, nonatomic) IBOutlet UIView *pinContainer;
@property (weak, nonatomic) IBOutlet UIView *incorrectPinView;

@property (weak,nonatomic) id <PinCoordinator> delegate;
@property (assign,nonatomic) PinType type;

-(void)actionIncorrectPin;
-(void)accessPinDenied;

@end
