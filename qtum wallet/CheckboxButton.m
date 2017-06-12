//
//  CheckboxButton.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 12.06.17.
//  Copyright © 2017 PixelPlex. All rights reserved.
//

#import "CheckboxButton.h"

@interface CheckboxButton()

@property (nonatomic) BOOL checked;
@property (nonatomic) BOOL isSetup;

@property (weak, nonatomic) IBOutlet UIView *checkView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *checkImageView;

@end

@implementation CheckboxButton

- (void)setup {
    self.checkView.layer.borderWidth = 2.0f;
    [self changeViewByCheckState];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap)];
    [self addGestureRecognizer:recognizer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.isSetup) {
        self.isSetup = YES;
        [self setup];
    }
}

#pragma mark - Actions

- (void)actionTap {
    self.checked = !self.checked;
    [self changeViewByCheckState];
    
    if ([self.delegate respondsToSelector:@selector(didStateChanged:)]) {
        [self.delegate didStateChanged:self];
    }
}

#pragma mark - Public

- (BOOL)isChecked {
    return self.checked;
}

- (void)setCheck:(BOOL)value {
    self.checked = value;
    [self changeViewByCheckState];
}

- (void)setTitle:(NSString *)value {
    [self.titleLabel setText:value];
}

#pragma mark - Private

- (void)changeViewByCheckState {
    self.checkImageView.hidden = !self.checked;
    self.checkView.layer.borderColor = self.checked ? customRedColor().CGColor : customBlueColor().CGColor;
    self.checkView.backgroundColor = self.checked ? customRedColor() : customBlackColor();
}

@end
