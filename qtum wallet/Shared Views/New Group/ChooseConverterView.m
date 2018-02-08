//
//  ChooseConverterView.m
//  qtum wallet
//
//  Created by Vladimir Lebedevich on 08.02.2018.
//  Copyright © 2018 QTUM. All rights reserved.
//

#import "ChooseConverterView.h"

@interface ChooseConverterView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topOffset;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leading;
@property (weak, nonatomic) IBOutlet UIButton *hexButton;
@property (weak, nonatomic) IBOutlet UIButton *numberButton;
@property (weak, nonatomic) IBOutlet UIButton *textButton;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;

@end

@implementation ChooseConverterView

-(void)awakeFromNib {
    
    [super awakeFromNib];
    [self configLocalization];
    [self configView];
}

-(void)configView {}

-(void)configLocalization {
    
    [self.hexButton setTitle:NSLocalizedString(@"Hex", @"") forState:UIControlStateNormal];
    [self.numberButton setTitle:NSLocalizedString(@"Number", @"") forState:UIControlStateNormal];
    [self.textButton setTitle:NSLocalizedString(@"Text", @"") forState:UIControlStateNormal];
    [self.addressButton setTitle:NSLocalizedString(@"Address", @"") forState:UIControlStateNormal];
}

- (void)removeSelf {
    __weak __typeof (self) weakSelf = self;
    
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

- (IBAction)didTapOnView:(id) sender {
    
    [self removeSelf];
}

-(void)setOffset:(CGRect) position {
    
    self.leading.constant = position.origin.x;
    self.topOffset.constant = position.origin.y;
}

- (IBAction)actionChooseType:(UIButton*) sender {
    
    [self.delegate didChoseType:sender.tag];
    [self removeSelf];
}

@end
