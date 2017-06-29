//
//  SelectSearchTypeView.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 27.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "SelectSearchTypeView.h"
#import "CheckboxButton.h"

@interface SelectSearchTypeView () <CheckboxButtonDelegate>

@property (weak, nonatomic) IBOutlet CheckboxButton *leftButton;
@property (weak, nonatomic) IBOutlet CheckboxButton *rightButton;

@property (nonatomic) NSInteger curretSelectedIndex;
@property (nonatomic) BOOL wasSetup;

@end

@implementation SelectSearchTypeView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.wasSetup) {
        self.wasSetup = YES;
        
        self.curretSelectedIndex = 0;
        [self changeButtonStatesByIndex:self.curretSelectedIndex];
        
        self.leftButton.delegate = self;
        self.rightButton.delegate = self;
        
        [self.leftButton setSquareBackroundColor:self.backgroundColor];
        [self.rightButton setSquareBackroundColor:self.backgroundColor];
    }
}

#pragma mark - CheckboxButtonDelegate

- (void)didStateChanged:(CheckboxButton *)sender {
    NSInteger index = 0;
    if (sender == self.rightButton) {
        index = 1;
    }
    
    [self changeButtonStatesByIndex:index];
    
    if (self.curretSelectedIndex == index) {
        return;
    }
    
    self.curretSelectedIndex = index;
    
    if ([self.delegate respondsToSelector:@selector(selectIndexChanged:)]) {
        [self.delegate selectIndexChanged:self.curretSelectedIndex];
    }
}

- (void)changeButtonStatesByIndex:(NSInteger)index {
    [self.leftButton setCheck:!index];
    [self.rightButton setCheck:index];
}

@end
