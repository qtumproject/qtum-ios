//
//  SeitchParameterView.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 09.06.17.
//  Copyright © 2017 QTUM. All rights reserved.
//

#import "SwitchParameterView.h"

@interface SwitchParameterView()

@property (weak, nonatomic) IBOutlet UILabel *falseLabel;
@property (weak, nonatomic) IBOutlet UILabel *trueLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchView;

@end

@implementation SwitchParameterView

- (IBAction)actionValueChanged:(id)sender {
    self.falseLabel.alpha = self.switchView.isOn ? 0.5f : 1.0f;
    self.trueLabel.alpha = self.switchView.isOn ? 1.0f : 0.5f;
    
    self.falseLabel.textColor = self.switchView.isOn ? customBlackColor() : customBlueColor();
    self.trueLabel.textColor = self.switchView.isOn ? customBlueColor() : customBlackColor();
    
    if (sender && [self.delegate respondsToSelector:@selector(switchValueChanged:)]) {
        [self.delegate switchValueChanged:self.switchView.isOn];
    }
}

- (void)changeSwitchValue:(BOOL)value {
    [self.switchView setOn:value];
    [self actionValueChanged:nil];
}

@end
